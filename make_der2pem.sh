#/usr/bin/env bash
# make_der2pem.sh
# 1/2019.0614, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ ! -s "$1" ];  then
	echo "USAGE: $0 <crt_file> [<extension='-pem.crt'>]"
	echo "The <crt_file> is the cert file, which should be exist!"
	echo "The <extension> will be appended after the file's main name."
	echo ""
	exit 1
fi

DER=$1
NAME=${DER%.*}
PEM=$NAME${2:-'-pem.crt'}

if [ -s $PEM ]; then
	echo "File '$PEM' exist!"
else
	openssl x509 -inform DER -outform PEM -in $DER -out $PEM
	[ "$?" -ne "0" ] && exit 2
	[ -f $PEM ] && echo "Done with '$PEM'!"
fi

echo ""

