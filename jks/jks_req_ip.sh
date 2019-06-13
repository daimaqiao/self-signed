#!/usr/bin/env bash
# jks_req_ip.sh
# 1/2019.0613, BY daimaqiao
#

if [ -z "$(which keytool)" ]; then
	echo "ERROR: Please install the 'keytool' (java) tools first!"
	echo ""
	exit 1
fi

if [ ! -s "$1" ]; then
	echo "USAGE: $0 <source_jks> [<ip_address>]"
	echo "The <source_jks> is the source keystorage, which should be generated first!"
	echo "This <ip_address> is default to the main name of <source_jks>."
	echo ""
	exit 1
fi

JKS=$1
NAME=${JKS%.*}
CSR=$NAME.csr
IPADDR=${2:-$NAME}

if [ -s $CSR ]; then
	echo "File '$CSR' exist!"
else

	keytool -certreq -keyalg RSA \
		-keystore $JKS \
		-alias $NAME \
		-ext san=ip:$IPADDR \
		-rfc \
		-file $CSR 

	[ "$?" -ne "0" ] && exit 2
	[ -f $CSR ] && echo "Done with '$CSR'!"
fi
echo ""

