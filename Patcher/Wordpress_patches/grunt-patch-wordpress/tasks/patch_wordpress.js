/*
 * grunt-patch-wordpress
 * https://github.com/WordPress/grunt-patch-wordpress
 * Based on https://gist.github.com/markjaquith/4219135
 *
 *
 * Copyright (c) 2013 Aaron Jorbin
 * Licensed under the MIT license.
 */

const request = require( 'request' );
const exec = require( 'child_process' ).exec;
const execSync = require( 'child_process' ).execSync;
const spawn = require( 'child_process' ).spawn;
const inquirer = require( 'inquirer' );
const url = require( 'url' );
const fs = require( 'fs' );
const trac = require( '../lib/trac.js' );
const patch = require( '../lib/patch.js' );
const regex = require( '../lib/regex.js' );
const xmlrpc = require( 'xmlrpc' );
const mapOldToNewFilePath = require( '../lib/map_old_to_new_file_path.js' );

module.exports = function ( grunt ) {
	let tempFile = 'wppatch.diff';
	const defaults = {
		tracUrl: 'core.trac.wordpress.org',
	};

	function isSvn() {
		return fs.existsSync( '.svn' );
	}

	function workingDir() {
		return process.cwd();
	}

	function applyPatch( patchUrl, done, options ) {
		grunt.verbose.write( patchUrl );
		const parsedUrl = url.parse( patchUrl );

		// What to do when either our patch is ready
		grunt.event.once( 'fileReady', ( level, moveToSrc ) => {
			const patchOptions = {};
			const patchArgs = [];

			// Set patch process to use the existing I/O streams, which will output
			// the command's results and allow for user input on patch error
			patchOptions.stdio = 'inherit';

			// Decide if we need to be in src
			if ( moveToSrc ) {
				patchOptions.cwd = workingDir() + '/src';
				tempFile = workingDir() + '/' + tempFile;
			}

			// Set the patch command's arguments
			patchArgs.push( '-p' + level );
			patchArgs.push( '--input=' + tempFile );

			grunt.log.debug(
				'patch options: ' + JSON.stringify( patchOptions )
			);
			grunt.log.debug(
				'patch arguments: ' + JSON.stringify( patchArgs )
			);
			grunt.log.debug( 'patch tempFile: ' + JSON.stringify( tempFile ) );

			// Maps old file paths in patches to new file paths.
			if ( options.file_mappings ) {
				mapOldToNewFilePath( tempFile, options.file_mappings );
			}

			const patchProcess = spawn( 'patch', patchArgs, patchOptions );

			patchProcess.on( 'exit', ( code, signal ) => {
				if ( signal ) {
					grunt.log.debug( 'error signal: ' + signal );
				}

				// if debug is enabled, don't delete the file
				if ( grunt.option( 'debug' ) ) {
					grunt.log.debug( 'File Saved' );
				} else {
					grunt.file.delete( tempFile );
				}

				done( code );
			} );
		} );

		// or we know we have failed
		grunt.event.once( 'fileFail', ( msg ) => {
			if ( 'string' === typeof msg ) {
				grunt.log.errorlns( msg );
			}

			done( false );
		} );

		// if patchUrl is a github url
		if ( regex.githubConvert( patchUrl ) ) {
			const diffUrl = regex.githubConvert( patchUrl );
			grunt.log.debug( 'github url detected: ' + diffUrl );

			getPatch( diffUrl, options );

			// if patchUrl is a full url and is a raw-attachement, just apply it
		} else if (
			parsedUrl.hostname === options.tracUrl &&
			parsedUrl.pathname.match( /raw-attachment/ )
		) {
			getPatch( patchUrl, options );

			// if patchUrl is full url and is an attachment, convert it to a raw attachment
		} else if (
			parsedUrl.hostname === options.tracUrl &&
			parsedUrl.pathname.match( /attachment/ ) &&
			parsedUrl.pathname.match( /(patch|diff)/ )
		) {
			getPatch( trac.convertToRaw( parsedUrl, options ) );

			// if patchUrl is just a ticket number, get a list of patches on that ticket and allow user to choose one
		} else if (
			parsedUrl.hostname === options.tracUrl &&
			parsedUrl.pathname.match( /ticket/ )
		) {
			getPatchFromTicket( patchUrl, options );

			// if we just enter a number, assume it is a ticket number
		} else if (
			null === parsedUrl.hostname &&
			! parsedUrl.pathname.match( /\./ )
		) {
			getPatchFromTicketNumber( patchUrl, options );

			// if patchUrl is a local file, just use that
		} else if ( null === parsedUrl.hostname ) {
			getLocalPatch( patchUrl, options );

			// We've failed in our mission
		} else {
			grunt.event.emit(
				'fileFile',
				'All matching failed.  Please enter a ticket url, ticket number, patch url'
			);
		}
	}

	function getPatchFromTicketNumber( patchUrl, options ) {
		grunt.log.debug( 'getPatchFromTicketNumber: ' + patchUrl );
		getPatchFromTicket(
			'https://' +
				options.tracUrl +
				'/attachment/ticket/' +
				patchUrl +
				'/',
			options
		);
	}

	function getPatchFromTicket( patchUrl, options ) {
		let matches;
		let longMatches;
		let matchUrl;
		let possiblePatches;

		grunt.log.debug( 'getPatchFromTicket: ' + patchUrl );

		const requestOptions = {
			url: patchUrl,
			headers: {
				'User-Agent':
					'grunt-patch-wordpress; https://github.com/WordPress/grunt-patch-wordpress',
			},
		};
		request( requestOptions, ( error, response, body ) => {
			if ( ! error && 200 === response.statusCode ) {
				matches = regex.patchAttachments( body );
				grunt.log.debug( 'matches: ' + JSON.stringify( matches ) );

				if ( null === matches ) {
					grunt.event.emit(
						'fileFail',
						patchUrl + '\ncontains no attachments'
					);
				} else if ( 1 === matches.length ) {
					matchUrl =
						options.tracUrl +
						regex.urlsFromAttachmentList( matches[ 0 ] )[ 1 ];
					getPatch(
						trac.convertToRaw( url.parse( 'https://' + matchUrl ) ),
						options
					);
				} else {
					longMatches = regex.longMatches( body );
					possiblePatches = regex.possiblePatches( longMatches );

					grunt.log.debug(
						'possiblePatches: ' + JSON.stringify( possiblePatches )
					);
					grunt.log.debug(
						'longMatches: ' + JSON.stringify( longMatches )
					);
					inquirer
						.prompt( [
							{
								type: 'list',
								name: 'patch_name',
								message: 'Please select a patch to apply',
								choices: possiblePatches,

								// preselect the most recent patch
								default: possiblePatches.length - 1,
							},
						] )
						.then( ( answers ) => {
							grunt.log.debug(
								'answers:' + JSON.stringify( answers )
							);
							matchUrl =
								options.tracUrl +
								regex.urlsFromAttachmentList(
									matches[
										possiblePatches.indexOf(
											answers.patch_name
										)
									]
								)[ 1 ];
							getPatch(
								trac.convertToRaw(
									url.parse( 'https://' + matchUrl )
								),
								options
							);
						} );
				}
			} else {
				// something went wrong
				grunt.event.emit(
					'fileFail',
					'getPatchFromTicket fail \n status: ' + response.statusCode
				);
			}
		} );

		grunt.event.emit( 'fileFile', 'method not available yet' );
	}

	function getLocalPatch( patchUrl ) {
		const body = grunt.file.read( patchUrl );
		const level = patch.isAb( body ) ? 1 : 0;
		const moveToSrc = patch.moveToSrc( body );

		grunt.file.copy( patchUrl, tempFile );
		grunt.event.emit( 'fileReady', level, moveToSrc );
	}

	function getPatch( patchUrl ) {
		grunt.log.debug( 'getting patch: ' + patchUrl );

		const requestOptions = {
			url: patchUrl,
			headers: {
				'User-Agent':
					'grunt-patch-wordpress; https://github.com/WordPress/grunt-patch-wordpress',
			},
		};
		request( requestOptions, ( error, response, body ) => {
			if ( ! error && 200 === response.statusCode ) {
				const level = patch.isAb( body ) ? 1 : 0;
				const moveToSrc = patch.moveToSrc( body );

				grunt.file.write( tempFile, body );
				grunt.event.emit( 'fileReady', level, moveToSrc );
			} else {
				// something went wrong
				grunt.event.emit(
					'fileFail',
					'getPatch_fail \n status: ' + response.statusCode
				);
			}
		} );
	}

	function fileFail( done, msg ) {
		grunt.log.errorlns( 'Nothing to patch.' );
		grunt.log.errorlns( '' );
		grunt.log.errorlns( '' );
		grunt.log.errorlns( 'To use this command, please:' );
		grunt.log.errorlns( '' );
		grunt.log.errorlns(
			'1) have a diff or patch in your WordPress Directory'
		);
		grunt.log.errorlns( '' );
		grunt.log.errorlns(
			'2) enter a ticket number, e.g. grunt patch:15705'
		);
		grunt.log.errorlns( '' );
		grunt.log.errorlns(
			'3) enter a ticket url, e.g. grunt patch:https://core.trac.wordpress.org/ticket/15705'
		);
		grunt.log.errorlns( '' );
		grunt.log.errorlns(
			'4) enter a patch url, e.g. grunt patch:https://core.trac.wordpress.org/attachment/ticket/11817/13711.diff'
		);
		grunt.log.errorlns( '' );

		if ( 'string' === typeof msg ) {
			grunt.verbose.errorlns( 'msg: ' + msg );
		}

		done( false );
	}

	function localFile( error, result, code, done, options ) {
		if ( ! error ) {
			const files = result
				.split( '\n' )
				.filter(
					( file ) =>
						file.includes( 'patch' ) || file.includes( 'diff' )
				);
			grunt.log.debug( 'files: ' + JSON.stringify( files ) );

			if ( 0 === files.length ) {
				fileFail( done );
			} else if ( 1 === files.length ) {
				applyPatch( regex.localFileClean( files[ 0 ] ), done, options );
			} else {
				inquirer
					.prompt( [
						{
							type: 'list',
							name: 'file',
							message: 'Please select a file to apply',
							choices: files,
						},
					] )
					.then( ( answers ) => {
						const file = regex.localFileClean( answers.file );
						applyPatch( file, done, options );
					} );
			}
		} else {
			fileFail( done, 'local file fail' );
		}
	}

	grunt.registerTask(
		'patch_wordpress',
		'Patch your develop-wordpress directory like a boss',
		function ( ticket, afterProtocal ) {
			const done = this.async();
			const options = this.options( defaults );

			// since URLs contain a : which is the seperator for grunt, we
			// need to reassemble the url.
			if ( 'undefined' !== typeof afterProtocal ) {
				ticket = ticket + ':' + afterProtocal;
			}

			grunt.log.debug( 'ticket: ' + ticket );
			grunt.log.debug( 'options: ' + JSON.stringify( options ) );

			if ( 'undefined' === typeof ticket ) {
				// look for diffs and patches in the root of the checkout and
				// prompt using inquirer to pick one

				const fileFinderCommand = isSvn()
					? 'svn status '
					: 'git ls-files --other --exclude-standard';

				exec( fileFinderCommand, ( error, result, code ) => {
					localFile( error, result, code, done, options );
				} );
			} else {
				applyPatch( ticket, done, options );
			}
		}
	);

	grunt.registerTask(
		'upload_patch',
		'Upload the current diff of your develop-wordpress directory to Trac',
		function ( ticketNumber ) {
			const done = this.async();
			const options = this.options( defaults );

			grunt.log.debug( 'ticketNumber: ' + ticketNumber );
			grunt.log.debug( 'options: ' + JSON.stringify( options ) );

			ticketNumber = parseInt( ticketNumber, 10 );
			if ( 'number' !== typeof ticketNumber ) {
				grunt.fail.warn(
					'A ticket number is required to upload a patch.'
				);
			}

			const uploadPatchWithCredentials = function ( username, password ) {
				const diffCommand = isSvn()
					? 'svn diff --diff-cmd diff'
					: 'git diff HEAD';

				if ( ! isSvn() ) {
					execSync( 'git add .' );
				}

				exec( diffCommand, ( error, result ) => {
					const client = xmlrpc.createSecureClient( {
						hostname: options.tracUrl,
						port: 443,
						path: '/login/xmlrpc',
						basic_auth: {
							// eslint-disable-line camelcase
							user: username,
							pass: password,
						},
					} );
					client.methodCall(
						'ticket.putAttachment',
						[
							ticketNumber,
							ticketNumber + '.diff',
							'', // description. empty for now.
							new Buffer.from(
								new Buffer.from( result ).toString( 'base64' ),
								'base64'
							),
							false, // never overwrite the old file
						],
						( err ) => {
							if ( ! isSvn() ) {
								exec( 'git reset' );
							}

							if ( null === err ) {
								grunt.log.writeln( 'Uploaded patch.' );
								done();
							} else {
								grunt.fail.warn(
									'Something went wrong when attempting to upload the patch. Please confirm your credentials and the ticket number. ' +
										err
								);
							}
						}
					);
				} );
			};
			if ( process.env.WPORG_USERNAME && process.env.WPORG_PASSWORD ) {
				uploadPatchWithCredentials(
					process.env.WPORG_USERNAME,
					process.env.WPORG_PASSWORD
				);
			} else {
				inquirer
					.prompt( [
						{
							type: 'input',
							name: 'username',
							message: 'Enter your WordPress.org username',
						},
						{
							type: 'password',
							name: 'password',
							message: 'Enter your WordPress.org password',
						},
					] )
					.then( ( answers ) => {
						uploadPatchWithCredentials(
							answers.username,
							answers.password
						);
					} );
			}
		}
	);
};
