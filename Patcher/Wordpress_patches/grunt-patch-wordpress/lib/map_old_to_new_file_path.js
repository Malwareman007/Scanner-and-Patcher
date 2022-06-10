const grunt = require( 'grunt' );

/**
 * Replaces file names in the passed filePath with the file names in the fileMappings.
 *
 * @param {string} filePath The path to the file where the filenames should be replaced.
 * @param {Object} fileMappings The file names to replace and the file names they should be replaced with.
 *
 * @return {void}
 */
function mapOldToNewFilePath( filePath, fileMappings ) {
	const body = grunt.file.read( filePath );
	let newBody;
	let oldPath;
	for ( oldPath in fileMappings ) {
		// Ensure only own properties are looped over.
		if ( ! fileMappings.hasOwnProperty( oldPath ) ) {
			continue;
		}

		// Regex to match the second filename of the diff header.
		const headerRegex = new RegExp(
			'((diff \\-\\-git .* )(' + oldPath + ')(\\n))',
			'ig'
		);

		// Regex to match the old and new file name of the chunks within the diff.
		const chunkFilenameRegex = new RegExp(
			'((-{3}|\\+{3})( ' + oldPath + '))',
			'ig'
		);

		if ( ! body.match( chunkFilenameRegex ) ) {
			continue;
		}

		const newPath = fileMappings[ oldPath ];

		newBody = body.replace( chunkFilenameRegex, '$2 ' + newPath );
		newBody = newBody.replace( headerRegex, '$2' + newPath + '$4' );

		// Logs the mapping.
		if ( body !== newBody ) {
			grunt.log.writeln(
				'Old file path ' +
					oldPath +
					' found in patch. This path has been automatically replaced by ' +
					newPath +
					'.'
			);
		}
	}

	// newBody only has a value when there was a match.
	if ( newBody ) {
		grunt.file.write( filePath, newBody );
	}
}

module.exports = mapOldToNewFilePath;
