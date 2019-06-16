#/usr/bin/bash
# make_local_root.sh
# 1/2019.0616, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ -z "$1" ]; then
	echo "USAGE: $0 <domain> [<subj>='CN=<domain>']"
	echo ""
	exit 1
fi

DOMAIN=$1
SUBJ=${2:-"/CN=$DOMAIN"}
KEY=$DOMAIN.key
CRT=$DOMAIN.crt

if [ -s $KEY ] || [ -s $CRT ]; then
	echo "File '$KEY' or '$CRT' exist!"
else
	openssl req -x509 -days 3650 -newkey rsa:2048 \
		-reqexts v3_req -extensions v3_ca -subj $SUBJ \
		-config openssl.cnf.0 \
		-keyout $KEY -out $CRT

	[ "$?" -ne "0" ] && exit 2
	[ -f $KEY ] && [ -f $CRT ] && echo "Done with '$KEY' and '$CRT'!"
fi
echo ""

