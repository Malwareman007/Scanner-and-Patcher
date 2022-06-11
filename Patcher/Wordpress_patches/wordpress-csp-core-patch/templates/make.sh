#!/bin/bash
cd "$(dirname "$0")"
nonce=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
mkdir -p ../wp-csp-patch
for tplfile in *.patc_; do
  output="../wp-csp-patch/$(basename $tplfile ".patc_").patch"
  sed "s/%%secret_placeholder%%/$nonce/g" "$tplfile" > $output
done
sed "s/%%secret_placeholder%%/$nonce/g" "nginx_site_config.tx_" > "../wp-csp-patch/nginx_site_config.txt"
cp apply.sh ../wp-csp-patch/.
echo "The output files are stored in the wp-csp-patch folder.\nMove the directory to WordPress' root and run 'wp-csp-patch/apply.sh' from there."
