ansible-patch-ssl3-poodle
=========================

Ansible playbook to remove support of ssl3 from browser (POODLE vulnerability)

# Test your browser :
- https://www.ssllabs.com/ssltest/viewMyClient.html

# Supported browsers :
- chromium on ubuntu

# Launch the patch on your local system :
    ansible-playbook -i "localhost," -c local patch-ssl3-poodle.yml --sudo -K

# More information :
- https://www.openssl.org/~bodo/ssl-poodle.pdf
