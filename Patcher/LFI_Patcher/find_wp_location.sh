#!/bin/bash


if [ -d "$1" ]; then

	if [ -z "$2" ];then
	    paths=(
		   'wp-content/plugins/revslider/inc_php/framework/image_view.class.php'
		   'wp-content/plugins/revslider/inc_php/image_view.class.php'
		  )
	else
		  paths=(
		   'wp-content/plugins/revslider/inc_php/framework/image_view.class.php'
		   'wp-content/plugins/revslider/inc_php/image_view.class.php'
		   "wp-content/themes/$2/revslider/framework/inc_php/image_view.class.php"
		   "wp-content/themes/$2/revslider/inc_php/image_view.class.php"
		  )
  fi
  
	for i in "${paths[@]}"
	do
    path="$1/"$i
		if [ -f $path ];
		then
   		patch $path < 'rev_slider.patch'
		fi
	done	

else
	echo "Invalid WordPress directory."
fi

