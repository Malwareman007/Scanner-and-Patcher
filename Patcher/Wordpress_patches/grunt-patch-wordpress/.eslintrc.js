module.exports = {
	root: true,
	env: {
		es6: true,
		node: true,
	},
	extends: 'plugin:@wordpress/eslint-plugin/recommended',
	rules: {
		'one-var': [ 'error', 'never' ],
		'prefer-arrow-callback': [ 'error' ],
	},
};
