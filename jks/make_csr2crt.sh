#/usr/bin/evn bash
# make_csr2crt.sh
# 1/2019.0613, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ ! -s "$1" ] || [ ! -s "$2" ] || [ ! -s "$3" ]; then
	echo "USAGE: $0 <root_crt> <root_key> <csr_file>"
	echo "The <root_crt> is the cert file of the root cert, which should be exist!"
	echo "The <root_key> is the key  file of the root cert, which should be exist also!"
	echo "The <csr_file> is the request to be signed, which should be generated first!"
	echo ""
	exit 1
fi

CA=$1
CAKEY=$2
CSR=$3
NAME=${CSR%.*}
CRT=$NAME.crt

echo "Make $CRT from $CSR"
if [ -s $CRT ]; then
	echo "File '$CRT' exist!"
else
	SERIAL="-CAcreateserial"
	[ -s $NAME.srl ] && SERIAL="-CAserial $NAME.srl"
	openssl x509 -req -days 3650 -in $NAME.csr -out $NAME.crt -CA $CA -CAkey $CAKEY $SERIAL

	[ "$?" -ne "0" ] && exit 2
	[ -f $CRT ] && echo "Done with '$CRT'!"
fi
echo ""

