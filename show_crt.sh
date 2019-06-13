#/bin/sh
# show_crt.sh
# 1/2019.0613, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ ! -s "$1" ];  then
	echo "USAGE: $0 <crt_file>"
	echo "The <crt_file> is the cert file, which should be exist!"
	echo ""
	exit 1
fi

openssl x509 -in $1 -noout -text
echo ""


