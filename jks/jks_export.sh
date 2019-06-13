#!/usr/bin/env bash
# jks_export.sh
# 1/2019.0613, BY daimaqiao
#

if [ -z "$(which keytool)" ]; then
	echo "ERROR: Please install the 'keytool' (java) tools first!"
	echo ""
	exit 1
fi

if [ ! -s "$1" ]; then
	echo "USAGE: $0 <source_jks>"
	echo "The <source_jks> is the source keystorage, which should be generated first!"
	echo ""
	exit 1
fi

JKS=$1
NAME=${JKS%.*}
CRT=$NAME.crt

if [ -s $CRT ]; then
	echo "File '$CRT' exist!"
else
	keytool -exportcert \
		-alias $NAME \
		-keystore $JKS \
		-rfc \
		-file $CRT

	[ "$?" -ne "0" ] && exit 2
	[ -f $CRT ] && echo "Done with '$CRT'!"
fi
echo ""

