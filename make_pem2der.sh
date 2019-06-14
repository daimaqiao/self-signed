#/usr/bin/env bash
# make_pem2der.sh
# 1/2019.0614, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ ! -s "$1" ];  then
	echo "USAGE: $0 <crt_file> [<extension='-der.crt'>]"
	echo "The <crt_file> is the cert file, which should be exist!"
	echo "The <extension> will be appended after the file's main name."
	echo ""
	exit 1
fi

PEM=$1
NAME=${PEM%.*}
DER=$NAME${2:-'-der.crt'}

if [ -s $DER ]; then
	echo "File '$DER' exist!"
else
	openssl x509 -inform PEM -outform DER -in $PEM -out $DER
	[ "$?" -ne "0" ] && exit 2
	[ -f $DER ] && echo "Done with '$DER'!"
fi

echo ""

