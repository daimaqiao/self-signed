#!/usr/bin/env bash
# make_p12_key_only.sh
# 1/2019.0613, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ ! -s "$1" ]; then
	echo "USAGE: $0 <source_p12>"
	echo "The <source_p12> is the source keystorage, which should be generated first!"
	echo ""
	exit 1
fi

P12=$1
NAME=${P12%.*}
CRT=$NAME.crt

if [ -s $CRT ]; then
	echo "File '$CRT' exist!"
else
	openssl pkcs12 -in $P12 -out $CRT -nokeys

	[ "$?" -ne "0" ] && exit 2
	[ -f $CRT ] && echo "Done with '$CRT'!"
fi
echo ""

