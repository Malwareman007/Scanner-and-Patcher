// Ensure both arguments are strings and that str begins with starts.
function startsWith( str, starts ) {
	return 0 === ( '' + str ).lastIndexOf( '' + starts, 0 );
}

module.exports = {
	isAb( diff ) {
		let ab = false;
		try {
			diff.split( '\n' ).forEach( ( line ) => {
				if ( startsWith( line, 'diff --git a/' ) ) {
					throw true;
				}
				if ( startsWith( line, 'Index: trunk/wp-' ) ) {
					throw true;
				}
			} );
		} catch ( e ) {
			ab = e;
		}

		return ab;
	},

	/**
	 * Check to see if we should apply the diff from the src dir
	 *
	 * @param {string} diff A string diff
	 * @return {boolean} true if we should go into src to apply the diff
	 */
	moveToSrc( diff ) {
		let src = false;
		const wpDashExceptions = [
			'.editorconfig',
			'.gitignore',
			'.jshintrc',
			'.travis.yml',
			'Gruntfile.js',
			'package.json',
			'phpunit.xml.dist',
			'wp-cli.yml',
			'wp-config-sample.php',
			'wp-tests-config-sample.php',
		];
		const noWpDashExceptions = [
			'index.php',
			'license.txt',
			'readme.html',
			'xmlrpc.php',
		];

		try {
			diff.split( '\n' ).forEach( ( line ) => {
				// these are often the first line
				if (
					startsWith( line, 'Index: src/' ) ||
					startsWith( line, 'Index: tests/' ) ||
					startsWith( line, 'Index: tools/' ) ||
					startsWith( line, 'diff --git src' ) ||
					startsWith( line, 'diff --git test' ) ||
					startsWith( line, 'diff --git tools' ) ||
					startsWith( line, 'diff --git a/src' ) ||
					startsWith( line, 'diff --git a/test' ) ||
					startsWith( line, 'diff --git a/tools' )
				) {
					throw false;
				}

				wpDashExceptions.forEach( ( exception ) => {
					if (
						startsWith( line, 'Index: ' + exception ) ||
						startsWith( line, 'diff --git ' + exception ) ||
						startsWith( line, 'diff --git a/' + exception )
					) {
						throw false;
					}
				} );

				noWpDashExceptions.forEach( ( exception ) => {
					if (
						startsWith( line, 'Index: ' + exception ) ||
						startsWith( line, 'diff --git ' + exception ) ||
						startsWith( line, 'diff --git a/' + exception )
					) {
						throw true;
					}
				} );

				if (
					startsWith( line, 'Index: wp-' ) ||
					startsWith( line, 'Index: trunk/wp-' ) ||
					startsWith( line, 'diff --git wp-' ) ||
					startsWith( line, 'diff --git a/wp-' )
				) {
					throw true;
				}
			} );
			throw true;
		} catch ( l ) {
			src = l;
		}
		return src;
	},
};
