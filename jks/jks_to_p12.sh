#!/usr/bin/env bash
# jks_to_p12.sh
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
P12=$NAME.p12

if [ -s $P12 ]; then
	echo "File '$P12' exist!"
else
	keytool -importkeystore \
		-srckeystore  $JKS -srcstoretype  JKS \
		-destkeystore $P12 -deststoretype PKCS12 \
		-srcalias  $NAME \
		-destalias $NAME

	[ "$?" -ne "0" ] && exit 2
	[ -f $P12 ] && echo "Done with '$P12'!"
fi
echo ""

