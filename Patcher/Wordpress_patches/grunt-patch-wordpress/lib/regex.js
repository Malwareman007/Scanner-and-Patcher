module.exports = {
	patchAttachments( html ) {
		return html.match(
			/<dt>\s*<a\s+href="([^"]+?)(diff|patch)"\s+title="View attachment">([^<]+)/g
		);
	},

	urlsFromAttachmentList( html ) {
		return html.match( /href="([^"]+)"/ );
	},

	longMatches( html ) {
		return html.match( /<dt([\s|\S]*?)dt>/g );
	},

	possiblePatches( longMatches ) {
		return longMatches
			.map( ( match ) => {
				if ( match.match( /(patch|diff)"/ ) ) {
					return (
						match
							// Remove any HTML tags.
							.replace( /<\/?[^>]+>/g, '' )
							// Collapse consecutive whitespace characters into one space.
							.replace( /\s+/g, ' ' )
							.trim()
					);
				}
				return false;
			} )
			.filter( Boolean );
	},

	localFileClean( file ) {
		return file.replace( '?', '' ).replace( /\s/g, '' );
	},

	githubConvert( url ) {
		const matches = url.match(
			/(?:github\.com|patch-diff.githubusercontent.com\/raw)\/((?:[^\/]+\/){2}pull\/[0-9]*)/
		);
		if ( matches ) {
			return `https://patch-diff.githubusercontent.com/raw/${ matches[ 1 ] }.diff`;
		}
		return false;
	},
};
