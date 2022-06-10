'use strict';

const grunt = require( 'grunt' );
const patch = require( '../lib/patch.js' );
const url = require( 'url' );
const trac = require( '../lib/trac.js' );
const mapOldToNewFilePath = require( '../lib/map_old_to_new_file_path.js' );

describe( 'grunt_patch_wordpress', () => {
	describe( 'initial checks', () => {
		it( 'a is a', () => {
			expect( 'a' ).toEqual( 'a' );
		} );
	} );

	it( 'convertToRaw converts urls', () => {
		expect(
			trac.convertToRaw(
				url.parse(
					'https://core.trac.wordpress.org/attachment/ticket/26700/26700.diff'
				)
			)
		).toEqual(
			'https://core.trac.wordpress.org/raw-attachment/ticket/26700/26700.diff'
		);
	} );

	describe( 'Level Calculator', () => {
		// @TODO: Find alot of patches to use here

		it( '26602.2.diff is 0', () => {
			const file = grunt.file.read( 'test/fixtures/26602.2.diff' );
			expect( patch.isAb( file ) ).toBe( false );
		} );
	} );

	describe( 'mapOldToNewFilePath', () => {
		const fileMappings = {
			'src/wp-admin/js/color-picker.js':
				'src/js/_enqueues/lib/color-picker.js',
			'wp-admin/js/color-picker.js': 'js/_enqueues/lib/color-picker.js',
		};

		describe( 'old to new', () => {
			beforeAll( () => {
				grunt.file.copy(
					'./test/fixtures/patch_wordpress_1.diff',
					'./test/tmp/patch_wordpress_1_copy.diff'
				);
				mapOldToNewFilePath(
					'./test/tmp/patch_wordpress_1_copy.diff',
					fileMappings
				);
			} );

			it( 'replaces old file paths with new file paths in the diff', () => {
				const expected = grunt.file.read(
					'./test/expected/patch_wordpress_1.diff'
				);
				const actual = grunt.file.read(
					'./test/tmp/patch_wordpress_1_copy.diff'
				);

				expect( actual ).toEqual( expected );
			} );

			afterAll( () => {
				grunt.file.delete( './test/tmp/patch_wordpress_1_copy.diff' );
			} );
		} );

		describe( 'new stay unchanged', () => {
			beforeAll( () => {
				grunt.file.copy(
					'./test/fixtures/patch_wordpress_2.diff',
					'./test/tmp/patch_wordpress_2_copy.diff'
				);
				mapOldToNewFilePath(
					'./test/tmp/patch_wordpress_2_copy.diff',
					fileMappings
				);
			} );

			it( "doesn't replace new file paths", () => {
				const expected = grunt.file.read(
					'./test/expected/patch_wordpress_2.diff'
				);
				const actual = grunt.file.read(
					'./test/tmp/patch_wordpress_2_copy.diff'
				);

				expect( actual ).toEqual( expected );
			} );

			afterAll( () => {
				grunt.file.delete( './test/tmp/patch_wordpress_2_copy.diff' );
			} );
		} );

		describe( 'unknown stay unchanged', () => {
			beforeAll( () => {
				grunt.file.copy(
					'./test/fixtures/patch_wordpress_3.diff',
					'./test/tmp/patch_wordpress_3_copy.diff'
				);
				mapOldToNewFilePath(
					'./test/tmp/patch_wordpress_3_copy.diff',
					fileMappings
				);
			} );

			it( "doesn't replace file paths that are not in the file mappings object", () => {
				const expected = grunt.file.read(
					'./test/expected/patch_wordpress_3.diff'
				);
				const actual = grunt.file.read(
					'./test/tmp/patch_wordpress_3_copy.diff'
				);

				expect( actual ).toEqual( expected );
			} );

			afterAll( () => {
				grunt.file.delete( './test/tmp/patch_wordpress_3_copy.diff' );
			} );
		} );

		describe( 'new stay unchanged, old to new', () => {
			beforeAll( () => {
				grunt.file.copy(
					'./test/fixtures/patch_wordpress_4.diff',
					'./test/tmp/patch_wordpress_4_copy.diff'
				);
				mapOldToNewFilePath(
					'./test/tmp/patch_wordpress_4_copy.diff',
					fileMappings
				);
			} );

			it(
				"replaces old file paths with new file paths but doesn't replace file paths that are not " +
					'in the file mappings object in a diff file with multiple diffs',
				() => {
					const expected = grunt.file.read(
						'./test/expected/patch_wordpress_4.diff'
					);
					const actual = grunt.file.read(
						'./test/tmp/patch_wordpress_4_copy.diff'
					);

					expect( actual ).toEqual( expected );
				}
			);

			afterAll( () => {
				grunt.file.delete( './test/tmp/patch_wordpress_4_copy.diff' );
			} );
		} );

		describe( 'new and unknown stay unchanged', () => {
			beforeAll( () => {
				grunt.file.copy(
					'./test/fixtures/patch_wordpress_5.diff',
					'./test/tmp/patch_wordpress_5_copy.diff'
				);
				mapOldToNewFilePath(
					'./test/tmp/patch_wordpress_5_copy.diff',
					fileMappings
				);
			} );

			it(
				"doesn't replaces new file paths and file paths that are not in the file mappings object in a diff file" +
					' with multiple diffs',
				() => {
					const expected = grunt.file.read(
						'./test/expected/patch_wordpress_5.diff'
					);
					const actual = grunt.file.read(
						'./test/tmp/patch_wordpress_5_copy.diff'
					);

					expect( actual ).toEqual( expected );
				}
			);

			afterAll( () => {
				grunt.file.delete( './test/tmp/patch_wordpress_5_copy.diff' );
			} );
		} );

		describe( 'new and unknown stay unchanged, old to new', () => {
			beforeAll( () => {
				grunt.file.copy(
					'./test/fixtures/patch_wordpress_6.diff',
					'./test/tmp/patch_wordpress_6_copy.diff'
				);
				mapOldToNewFilePath(
					'./test/tmp/patch_wordpress_6_copy.diff',
					fileMappings
				);
			} );

			it( 'only replaces old file paths in a diff file with multiple diffs', () => {
				const expected = grunt.file.read(
					'./test/expected/patch_wordpress_6.diff'
				);
				const actual = grunt.file.read(
					'./test/tmp/patch_wordpress_6_copy.diff'
				);

				expect( actual ).toEqual( expected );
			} );

			afterAll( () => {
				grunt.file.delete( './test/tmp/patch_wordpress_6_copy.diff' );
			} );
		} );

		// There is no src folder in core.
		describe( 'non-src old to new', () => {
			beforeAll( () => {
				grunt.file.copy(
					'./test/fixtures/patch_wordpress_7.diff',
					'./test/tmp/patch_wordpress_7_copy.diff'
				);
				mapOldToNewFilePath(
					'./test/tmp/patch_wordpress_7_copy.diff',
					fileMappings
				);
			} );

			it( 'replaces old file paths with new file paths in a diff with non-src file paths', () => {
				const expected = grunt.file.read(
					'./test/expected/patch_wordpress_7.diff'
				);
				const actual = grunt.file.read(
					'./test/tmp/patch_wordpress_7_copy.diff'
				);

				expect( actual ).toEqual( expected );
			} );

			afterAll( () => {
				grunt.file.delete( './test/tmp/patch_wordpress_7_copy.diff' );
			} );
		} );
	} );
} );
