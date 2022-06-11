#!/bin/bash
cd "$(dirname "$0")"
if [ -d "../wp-includes" ] && [ -f "../wp-includes/version.php" ]; then
  wp_version=$(grep wp_version ../wp-includes/version.php | awk -F "'" '{print $2}' | tr -d '\n');
  echo "Attempting to patch WordPress v. $wp_version"
  n=0
  for patch_file in wp-$wp_version.*.patch; do
    target_file=$(grep -e "^--- " $patch_file | awk -F " " '{print $2}' | tr -d '\n');
    echo "Target: $target_file"
    if [ -f "../wp-includes/$target_file" ]; then
      if [ ! -f "../wp-includes/$target_file.original" ]; then
        cp -f "../wp-includes/$target_file" "../wp-includes/$target_file.original"
      fi
      patch "../wp-includes/$target_file" < $patch_file
      ((n=n+1))
    fi
  done
  echo "$n patches applied for version $wp_version"
else
  echo "This script must be run from WordPress' root directory."
fi
