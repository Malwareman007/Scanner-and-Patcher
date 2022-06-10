 ## [Patch] LFI (revslider) vulnerability

***In December 2014 thousands of pages based on WordPress suffered a large amount of cyber attacks. The problem boils down to a Local File Inclusion (LFI) vulnerability, a widely used plugin in WordPress templates, **Revolution Slider (revslider)**.*** 

***This is a serious problem, which allows the attacker access to system files without any restrictions, for example the file **/etc/passwd** or the WordPress **wp-config.php** file, which has the authentication data with the system data base.***

```html
LFI exploit: http://yourdomainhere.com/wp-admin/admin-ajax.php?action=revslider_show_image&img=../wp-config.php
```

The solution to vulnerability patch is updating the plugin to the latest version, however, this can bring some compatibility problems and dependence on certain systems. To this end, a corrective patch is herein distributed.
# Use
In order to resolve this vulnerability you have two possibilities:
* Using a bash script provided with the patch, 
***or if you are an experienced user,***
* Use the corrective patch directly in the file.

The file to be updated is as follows: image_view.class.php, and can be found on the directories described below.


    wp-content/plugins/revslider/inc_php/framework/
    wp-content/plugins/revslider/inc_php/
    wp-content/themes/(your theme name)/revslider/framework/inc_php/
    wp-content/themes/(your theme name)/revslider/inc_php/

To use it, enter in the command line:

```shell
./find_wp_location {wordpress_path}
```

or

```shell
./find_wp_location {wordpress_path} {theme_name}
```

For experiente users, use:
```shell
patch image_view.class.php < rev_slider.patch
```

At the end, the follows message is presented in terminal:


*patching file {wordpress_path}/wp-content/plugins/revslider/inc_php/image_view.class.php*


