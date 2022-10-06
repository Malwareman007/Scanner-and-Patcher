#!/usr/bin/env python
# Example of unpatched system:
#
# * /WebResource.axd?d=kHoDoPikaYfoTe1m9Ol5iQ2
# * /ScriptResource.axd?d=2nYOzoKtRvjs-g53K3r7VKmEXeQl_XMNY8nDEwcgwGVcS5Z8b9GanbNdzIgg493kfB_oInMb2DtFFEy5e-ajqdwMbg1F96l10
#
# Examples of patched system:
#
# * /WebResource.axd?d=VHYaLecZ91Zjq-_4mV3ftpYrTteh9kHzk9zwLyjpAZAOjWL3nbx1SmIeGdHJwBu_koMj8ZGAqrtxCJkW0
# * /ScriptResource.axd?d=Gcb5Zt1XkIPHAYC3l5vZ4QidrZMKISjkqnMQRQDqRD88oxkWIL1kNBQThGrDJBbaKqPd9AyT-jF1EhM-rame5NXv7RLQRhtlz-xfoQlHXf_pjgiBJW7ntGxhegohUeNFlo9x8_RMU6ocDmwwK6dfIRDFbX01

import sys


def base64decode(string):
    return string.decode("base64")


def hexdecode(string):
    string = string.lower()

    if string.startswith("0x"):
        string = string[2:]

    return string.decode("hex")


def hexencode(string):
    return string.encode("hex")


def dotNetUrlTokenDecode(string):
    """
    Ported from padbuster v0.3 by Brian Holyfield:

    sub web64Decode {
     my ($input, $net) = @_;
     # net: 0=No Padding Number, 1=Padding (NetUrlToken)
     $input =~ s/\-/\+/g;
     $input =~ s/\_/\//g;
     if ($net == 1)
     {
      my $count = chop($input);
      $input = $input.("=" x int($count));
     }
     return decode_base64($input);
    }
    """

    string = string.replace("-", "+").replace("_", "/")
    count = string[-1]

    if count.isdigit():
        string = string[:-1] + ("=" * int(count))

    return base64decode(string)


def usage():
    print
    """
Use:

  ./ms10-070_check.py <encrypted_d_block>

Note:

  Encrypted 'd' block MUST be from ScriptResource.axd or WebResource.axd.
  Parse the application response body to find a valid one.

Examples:

  With ScriptResource.axd 'd' block:
  $ ./ms10-070_check.py 2nYOzoKtRvjs-g53K3r7VKmEXeQl_XMNY8nDEwcgwGVcS5Z8b9GanbNdzIgg493kfB_oInMb2DtFFEy5e-ajqdwMbg1F96l10
  Your application is VULNERABLE, patch against MS10-070

  With WebResource.axd 'd' block:
  ./ms10-070_check.py VHYaLecZ91Zjq-_4mV3ftpYrTteh9kHzk9zwLyjpAZAOjWL3nbx1SmIeGdHJwBu_koMj8ZGAqrtxCJkW0
  Your application is NOT vulnerable
"""


def main():
    if len(sys.argv) < 2:
        usage()
        sys.exit(1)

    if (len(dotNetUrlTokenDecode(sys.argv[1])) % 8) == 0:
        print
        "Your application is VULNERABLE, patch against MS10-070"
    else:
        print
        "Your application is NOT vulnerable"


if __name__ == '__main__':
    main()
