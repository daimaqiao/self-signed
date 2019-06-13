#!/usr/bin/env bash
# jks_init_ip.sh
# 1/2019.0613, BY daimaqiao
#

if [ -z "$(which keytool)" ]; then
	echo "ERROR: Please install the 'keytool' (java) tools first!"
	echo ""
	exit 1
fi

if [ -z "$1" ]; then
	echo "USAGE: $0 <ip_to_signed>"
	echo "The <ip_to_signed> is the static ip to be signed!"
	echo ""
	exit 1
fi

IPADDR=$1

if [ -s $IPADDR.jks ]; then
	echo "File '$IPADDR.jks' exist!"
else
	keytool -genkeypair -alias $IPADDR -keyalg RSA -keysize 2048 \
		-dname "C=CN/ST=$IPADDR, L=$IPADDR, O=$IPADDR, OU=$IPADDR, CN=$IPADDR" \
		-ext san=ip:$IPADDR -validity 3650 \
		-keystore $IPADDR.jks

	[ "$?" -ne "0" ] && exit 2
	[ -f $IPADDR.jks ] && echo "Done with '$IPADDR.jks'!"
fi
echo ""

