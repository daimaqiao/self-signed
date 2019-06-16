#/usr/bin/env bash
# make_show.sh
# 1/2019.0614, BY daimaqiao
# 2/2019.0616, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

INFORM=
shopt -s nocasematch
case "$2" in
	pem) INFORM="-inform pem";;
	der) INFORM="-inform der";;
esac
shopt -u nocasematch

if [ ! -s "$1" ] || [ "$INFORM" = "err" ];  then
	echo "USAGE: $0 <crt_file> [<inform=pem|der>]"
	echo "The <crt_file> is the cert file, which should be exist!"
	echo "The <inform> may be specified as either 'pem' or 'der'."
	echo ""
	exit 1
fi

openssl x509 -in $1 -noout -text $INFORM
echo ""

