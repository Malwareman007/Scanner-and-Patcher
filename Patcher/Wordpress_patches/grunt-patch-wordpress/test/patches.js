const grunt = require( 'grunt' );
const patch = require( '../lib/patch.js' );
const coreGit = grunt.file.read( 'test/fixtures/core.git.diff' );
const coreSvn = grunt.file.read( 'test/fixtures/core.svn.diff' );
const developGit = grunt.file.read( 'test/fixtures/develop.git.diff' );
const developSvn = grunt.file.read( 'test/fixtures/develop.svn.diff' );
const coreIndexGit = grunt.file.read( 'test/fixtures/core.git.index.diff' );
const coreIndexSvn = grunt.file.read( 'test/fixtures/core.svn.index.diff' );
const developIndexGit = grunt.file.read(
	'test/fixtures/develop.git.index.diff'
);
const developIndexSvn = grunt.file.read(
	'test/fixtures/develop.svn.index.diff'
);
const developSampleGit = grunt.file.read(
	'test/fixtures/develop.git.wp-config-sample.diff'
);
const developSampleSvn = grunt.file.read(
	'test/fixtures/develop.svn.wp-config-sample.diff'
);
const testsSvn = grunt.file.read( 'test/fixtures/tests.develop.svn.diff' );
const testsGit = grunt.file.read( 'test/fixtures/tests.develop.git.diff' );
const abyes = grunt.file.read( 'test/fixtures/git.diff.ab.diff' );
const coreTrunkSvn = grunt.file.read( 'test/fixtures/core.svn.trunk.diff' );

describe( 'Patch helpers', () => {
	it( 'git a/b diffs should not automatticaly trigger moving to src', () => {
		expect( patch.moveToSrc( abyes ) ).not.toBe( true );
	} );

	it( 'tests diffs should always be applied in the root of the checkout', () => {
		expect( patch.moveToSrc( testsGit ) ).not.toBe( true );
		expect( patch.moveToSrc( testsSvn ) ).not.toBe( true );
	} );

	it( 'dev.git diffs should always be applied in the root of the checkout', () => {
		expect( patch.moveToSrc( developGit ) ).not.toBe( true );
		expect( patch.moveToSrc( developIndexGit ) ).not.toBe( true );
	} );

	it( 'dev.svn diffs should always be applied in the root of the checkout', () => {
		expect( patch.moveToSrc( developSvn ) ).not.toBe( true );
		expect( patch.moveToSrc( developIndexSvn ) ).not.toBe( true );
	} );

	it( 'core.git.wordpress.org diffs should always be applied in the svn folder', () => {
		expect( patch.moveToSrc( coreGit ) ).toBe( true );
	} );

	it( 'core.svn.wordpress.org diffs should always be applied in the svn folder', () => {
		expect( patch.moveToSrc( coreSvn ) ).toBe( true );
	} );

	it( 'core.svn.wordpress.org diffs from trunk should always be applied in the src folder', () => {
		expect( patch.moveToSrc( coreTrunkSvn ) ).toBe( true );
		expect( patch.isAb( coreTrunkSvn ) ).toBe( true );
	} );

	it( 'index.php should always be applied in the src folder', () => {
		expect( patch.moveToSrc( coreIndexSvn ) ).toBe( true );
		expect( patch.moveToSrc( coreIndexGit ) ).toBe( true );
	} );

	it( 'wp-config-sample.php should always be applied in the root folder', () => {
		expect( patch.moveToSrc( developSampleSvn ) ).not.toBe( true );
		expect( patch.moveToSrc( developSampleGit ) ).not.toBe( true );
	} );

	it( 'isAb should return true on patches with a/ b/ style', () => {
		expect( patch.isAb( abyes ) ).toBe( true );
	} );

	it( 'isAb should return false on patches without a/ b/ style', () => {
		expect( patch.isAb( developSampleGit ) ).not.toBe( true );
		expect( patch.isAb( developSampleSvn ) ).not.toBe( true );
		expect( patch.isAb( coreIndexGit ) ).not.toBe( true );
		expect( patch.isAb( coreIndexSvn ) ).not.toBe( true );
		expect( patch.isAb( coreGit ) ).not.toBe( true );
		expect( patch.isAb( coreSvn ) ).not.toBe( true );
		expect( patch.isAb( developGit ) ).not.toBe( true );
		expect( patch.isAb( developSvn ) ).not.toBe( true );
		expect( patch.isAb( developIndexGit ) ).not.toBe( true );
		expect( patch.isAb( developIndexSvn ) ).not.toBe( true );
		expect( patch.isAb( testsGit ) ).not.toBe( true );
		expect( patch.isAb( testsSvn ) ).not.toBe( true );
	} );
} );
