#/usr/bin/bash
# make_root.sh
# 1/2016.0307, BY daimaqiao
# 2/2019.0616, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ -z "$1" ]; then
	echo "USAGE: $0 <domain> [<subj>, like '/CN=daimaqiao']"
	echo ""
	exit 1
fi
DOMAIN=$1
#SUBJ="/C=CN/ST=daimaqiao/L=daimaqiao/O=daimaqiao/OU=daimaqiao/CN=daimaqiao"
SUBJ= [ -n "$2" ] && SUBJ="-subj $2"

echo "1. Generate the private key file ..."
if [ -s $DOMAIN.key ]; then
	echo "File '$DOMAIN.key' exist!"
else
	openssl genrsa -out $DOMAIN.key 2048
	[ "$?" -ne "0" ] && exit 2
	[ -s $DOMAIN.key ] && echo "Done with '$DOMAIN.key'!"
fi
echo ""

echo "2. Generate the request to be signed ..."
if [ -s $DOMAIN.csr ]; then
	echo "File '$DOMAIN.csr' exist!"
else
	openssl req -new -sha256 -key $DOMAIN.key -out $DOMAIN.csr $SUBJ
	[ "$?" -ne "0" ] && exit 2
	[ -f $DOMAIN.csr ] && echo "Done with '$DOMAIN.csr'!"
fi
echo ""

echo "3. Generate the self-signed certificate ..."
if [ -s $DOMAIN.crt ]; then
	echo "File '$DOMAIN.crt' exist!"
else
	openssl x509 -req -sha256 -days 3650 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.crt
	[ "$?" -ne "0" ] && exit 2
	[ -f $DOMAIN.crt ] && echo "Done with '$DOMAIN.crt'!"
fi
echo ""

