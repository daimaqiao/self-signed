#!/usr/bin/env bash
# make_key_crt_p12.sh
# 1/2019.0614, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ ! -s "$1" ] || [ ! -s "$2" ]; then
	echo "USAGE: $0 <crt> <key> [<name>]"
	echo "The <key> is private key, which should be exist!"
	echo "The <crt> is public cert, which should be exist also!"
	echo "The <name> is default to the main name of <crt>."
	echo ""
	exit 1
fi

KEY=$1
CRT=$2
NAME=${CRT%.*}
P12=${3:-$NAME}.p12

if [ -s $P12 ]; then
	echo "File '$P12' exist!"
else
	openssl pkcs12 -export -in $CRT -inkey $KEY -out $P12

	[ "$?" -ne "0" ] && exit 2
	[ -f $P12 ] && echo "Done with '$P12'!"
fi
echo ""

