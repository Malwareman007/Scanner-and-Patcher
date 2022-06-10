const url = require( 'url' );
const grunt = require( 'grunt' );

module.exports = {
	convertToRaw( parsedUrl ) {
		grunt.log.debug( 'convertToRaw: ' + JSON.stringify( parsedUrl ) );
		parsedUrl.pathname = parsedUrl.pathname.replace(
			/attachment/,
			'raw-attachment'
		);
		grunt.log.debug( 'converted_from_raw: ' + url.format( parsedUrl ) );
		return url.format( parsedUrl );
	},
};
