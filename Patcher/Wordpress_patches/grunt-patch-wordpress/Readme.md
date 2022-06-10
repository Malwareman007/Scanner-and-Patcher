# grunt-patch-wordpress
[![Build Status](https://github.com/makandra/angular_xss/workflows/Tests/badge.svg)](https://github.com/Malwareman007/Open_Source_Web-Vulnerability-Scanner-and-Patcher/actions)
> Patch your develop-wordpress directory like a boss (also works on other trac based projects)

## Getting Started
This plugin requires Grunt `~0.4.5`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
  npm install grunt-patch-wordpress --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-patch-wordpress');
```

## The "patch_wordpress" task
```js
patch_wordpress{
  tracUrl: 'core.trac.wordpress.org'
}
```

## Apply a patch from the command line

1. Have a diff or a patch file in your working Directory, then run ```grunt patch```.
If multiple files are found, you'll be asked which one to apply.

2. Enter a ticket number, e.g.
  * `grunt patch:15705`

3. Enter a ticket url, e.g.
  * `grunt patch:https://core.trac.wordpress.org/ticket/15705`

4. Enter a patch url, e.g.
  * `grunt patch:https://core.trac.wordpress.org/attachment/ticket/11817/13711.diff`

5. Enter a github url that points to a changeset such as a Pull Request, e.g.
  * `grunt patch:https://github.com/aaronjorbin/develop.wordpress/pull/23`

## Upload a patch from the command line

After you've made changes to your local WordPress develop repository, you can upload a patch file directly to a Trac ticket. e.g. given the ticket number is 2907,

```bash
grunt upload_patch:2907
```

You can also store your WordPress.org credentials in environment variables. Please exercise caution when using this option, as it may cause your credentials to be leaked!

```bash
export WPORG_USERNAME=matt
export WPORG_PASSWORD=MyPasswordIsVerySecure12345
grunt uploadPatch:40000
```

## Using the file_mappings option
If you'd like to map old file paths in your patch to new file paths during the patching process, you can pass a file mappings object as an option. Using this option can be helpful when the file paths in the project have been changed since you've created your patch.

The file mappings object should contain old file paths and the corresponding new file paths. In the Gruntfile.js of your project, this would look like this:

```
patch: {
	options: {
		file_mappings: {
			'old_path1': 'new_path1',
			'old_path2': 'new_path2',
			'old_path3': 'new_path3',
		}
	}
}
```
 In this example, the patch task will look for 'old_path1', 'old_path2' and 'old_path3' in your patch and replace them during patching with 'new_path1', 'new_path2', and 'new_path3' respectively.

## Contributing

Please follow the [WordPress coding standards](https://make.wordpress.org/core/handbook/best-practices/coding-standards/javascript/).

* Add unit tests and documentation for any new or changed functionality.
* Lint and test your code using `npm run lint` and `npm run test`.
