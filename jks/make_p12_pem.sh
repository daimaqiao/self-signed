#!/usr/bin/env bash
# make_p12_pem.sh
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
PEM=$NAME.pem

if [ -s $PEM ]; then
	echo "File '$PEM' exist!"
else
	openssl pkcs12 -in $P12 -out $PEM

	[ "$?" -ne "0" ] && exit 2
	[ -f $PEM ] && echo "Done with '$PEM'!"
fi
echo ""

