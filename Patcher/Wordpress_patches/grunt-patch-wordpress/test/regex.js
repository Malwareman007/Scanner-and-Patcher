const grunt = require( 'grunt' );
const regex = require( '../lib/regex.js' );
const html23988 = grunt.file.read( 'test/fixtures/23988.html' );
const html23989 = grunt.file.read( 'test/fixtures/23989.html' );
const html23994 = grunt.file.read( 'test/fixtures/23994.html' );

describe( 'regular expressions', () => {
	it( 'multiple patches on a ticket with non patches as well', () => {
		const matches = regex.patchAttachments( html23988 );
		const longMatches = regex.longMatches( html23988 );
		const possiblePatches = regex.possiblePatches( longMatches );

		expect( matches.length ).toBe( 2 );
		expect( longMatches.length ).toBe( 4 );
		expect( possiblePatches ).toEqual( [
			'edit-form-comment.diff​ (626 bytes) - added by Thaicloud 7 weeks ago.',
			'23988-edit-comment.diff​ (1.1 KB) - added by seanchayes 13 days ago.',
		] );
	} );

	it( 'one patch on a ticket', () => {
		const matches = regex.patchAttachments( html23994 );

		expect( matches.length ).toBe( 1 );
	} );

	it( 'url from a list of attachments', () => {
		const matches = regex.patchAttachments( html23994 );
		const url =
			'core.trac.wordpress.org' +
			regex.urlsFromAttachmentList( matches[ 0 ] )[ 1 ];

		expect( url ).toBe(
			'core.trac.wordpress.org/attachment/ticket/23994/23994.diff'
		);
	} );

	it( 'no patches on a ticket', () => {
		const matches = regex.patchAttachments( html23989 );

		expect( matches ).toBeNull();
	} );

	it( 'filenames should be cleaned', () => {
		const filename = '?       one.diff';

		expect( regex.localFileClean( filename ) ).toEqual( 'one.diff' );
	} );

	it.each( [
		[ 'https://github.com/WordPress/wordpress-develop/pull/740/', false ], // trailing slash
		[ 'https://github.com/WordPress/wordpress-develop/pull/740', false ], // no trailing slash
		[
			'https://github.com/WordPress/wordpress-develop/pull/740/checks',
			false,
		], // checks
		[
			'https://github.com/WordPress/wordpress-develop/pull/740/files',
			false,
		], // files
		[
			'https://github.com/WordPress/wordpress-develop/pull/740.diff',
			false,
		], // already diffed
		[
			'https://github.com/WordPress/wordpress-develop/pull/740.patch',
			false,
		], // already patched
		[
			'https://patch-diff.githubusercontent.com/raw/WordPress/wordpress-develop/pull/740.diff',
			false,
		], // already diffed and redirected
		[
			'https://patch-diff.githubusercontent.com/raw/WordPress/wordpress-develop/pull/740.patch',
			false,
		], // already diffed and redirected with patch
		[ 'https://git.com/WordPress/wordpress-develop/pull/740/files', true ], // not github url
	] )( 'github url %s should get normalized', ( url, blank ) => {
		const expected =
			'https://patch-diff.githubusercontent.com/raw/WordPress/wordpress-develop/pull/740.diff';

		if ( blank ) {
			expect( regex.githubConvert( url ) ).toBe( false );
		} else {
			expect( regex.githubConvert( url ) ).toEqual( expected );
		}
	} );
} );
