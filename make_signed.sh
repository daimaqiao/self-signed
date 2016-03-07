#/bin/sh
# make_signed.sh
# 1/2016.0307, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ ! -s "$1" ] || [ ! -s "$2" ] || [ -z "$3" ]; then
	echo "USAGE: $0 <root_crt> <root_key> <signed_name> [<signed_subj>, like '/C=CN/O=daimaqiao/...']"
	echo "The <root_crt> is the cert file of the root cert, which should be exist!"
	echo "The <root_key> is the key  file of the root cert, which should be exist also!"
	echo ""
	exit 1
fi

CA=$1
CAKEY=$2
NAME=$3
#SUBJ="/C=CN/ST=daimaqiao/L=daimaqiao/O=daimaqiao/OU=daimaqiao/CN=daimaqiao"
SUBJ= [ -n "$4" ] && SUBJ="-subj $4"

echo "1. Generate the private key file ..."
if [ -s $NAME.key ]; then
	echo "File '$NAME.key' exist!"
else
	openssl genrsa -des3 -out $NAME.key 2048
	[ "$?" -ne "0" ] && exit 2
	[ -s $NAME.key ] && echo "Done with '$NAME.key'!"
fi
echo "NOTICE: You may remove the pathphrase by typing the command of:"
echo "openssl rsa -in $NAME.key -out $NAME-unsecu.key"
echo ""

echo "2. Generate the request to be signed ..."
if [ -s $NAME.csr ]; then
	echo "File '$NAME.csr' exist!"
else
	openssl req -new -key $NAME.key -out $NAME.csr $SUBJ
	[ "$?" -ne "0" ] && exit 2
	[ -f $NAME.csr ] && echo "Done with '$NAME.csr'!"
fi
echo ""

echo "3. Generate the signed certificate ..."
if [ -s $NAME.crt ]; then
	echo "File '$NAME.crt' exist!"
else
	SERIAL="-CAcreateserial"
	[ -s $NAME.srl ] && SERIAL="-CAserial $NAME.srl"
	echo openssl x509 -req -days 3650 -in $NAME.csr -out $NAME.crt -CA $CA -CAkey $CAKEY $SERIAL
	openssl x509 -req -days 3650 -in $NAME.csr -out $NAME.crt -CA $CA -CAkey $CAKEY $SERIAL
	[ "$?" -ne "0" ] && exit 2
	[ -f $NAME.crt ] && echo "Done with '$NAME.crt'!"
fi
echo ""


