#/usr/bin/env bash
# make_signed_san_ip.sh
# 1/2019.0616, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ ! -s "$1" ] || [ ! -s "$2" ] || [ -z "$3" ]; then
	echo "USAGE: $0 <root_crt> <root_key> <domain_ip> [<subj>='CN=<domain_ip>']"
	echo "The <root_crt> is the cert file of the root cert, which should be exist!"
	echo "The <root_key> is the key  file of the root cert, which should be exist also!"
	echo ""
	exit 1
fi

CA=$1
CAKEY=$2
DOMAIN=$3
SUBJ=${4:-"/CN=$DOMAIN"}
KEY=$DOMAIN.key
CSR=$DOMAIN.csr

echo "Generate local openssl.cnf ..."
sed "s/_new_san_ip_value/$DOMAIN/g" openssl.cnf.1 > openssl.cnf
[ "$?" -ne "0" ] && exit 2


echo "1. Generate the the request to be signed and its private key ..."
if [ -s $KEY ] || [ -s $CSR ]; then
	echo "File '$KEY' or '$CSR' exist!"
else
	openssl req -new -sha256 -days 3650 -newkey rsa:2048 \
		-reqexts v3_req -extensions v3_ca -subj $SUBJ \
		-config openssl.cnf \
		-keyout $KEY -out $CSR
fi

NAME=${CA%.*}
SERIAL="-CAcreateserial"
[ -s $NAME.srl ] && SERIAL="-CAserial $NAME.srl"

echo "2. Generate the signed certificate ..."
if [ -s $DOMAIN.crt ]; then
	echo "File '$DOMAIN.crt' exist!"
else
	openssl x509 -req -sha256 -days 3650 \
		-in $DOMAIN.csr \
		-CA $CA -CAkey $CAKEY $SERIAL \
		-extfile openssl.cnf \
		-extensions SAN \
		-out $DOMAIN.crt

	[ "$?" -ne "0" ] && exit 2
	[ -f $DOMAIN.crt ] && echo "Done with '$DOMAIN.crt'!"
fi
echo ""

