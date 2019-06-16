#/usr/bin/bash
# make_root_san_ip.sh
# 1/2019.0616, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ -z "$1" ]; then
	echo "USAGE: $0 <domain_ip> [<subj>='CN=<domain_ip>']"
	echo ""
	exit 1
fi

DOMAIN=$1
SUBJ=${2:-"/CN=$DOMAIN"}
KEY=$DOMAIN.key
CRT=$DOMAIN.crt

echo "Generate local openssl.cnf ..."
sed "s/_new_san_ip_value/$DOMAIN/g" openssl.cnf.1 > openssl.cnf
[ "$?" -ne "0" ] && exit 2

if [ -s $KEY ] || [ -s $CRT ]; then
	echo "File '$KEY' or '$CRT' exist!"
else
	openssl req -x509 -days 3650 -newkey rsa:2048 \
		-reqexts v3_req -extensions v3_ca -subj $SUBJ \
		-config openssl.cnf \
		-keyout $KEY -out $CRT

	[ "$?" -ne "0" ] && exit 2
	[ -f $KEY ] && [ -f $CRT ] && echo "Done with '$KEY' and '$CRT'!"
fi
echo ""

