#/usr/bin/bash
# make_key2nopass.sh
# 1/2019.0705, BY daimaqiao
#

if [ -z "$(which openssl)" ]; then
	echo "ERROR: Please install the 'openssl' tools first!"
	echo ""
	exit 1
fi

if [ ! -s "$1" ];  then
	echo "USAGE: $0 <key_file> [<extension='-nopass.key'>]"
	echo "The <key_file> is the private key file, which should be exist!"
	echo "The <extension> will be appended after the file's main name."
	echo ""
	exit 1
fi

KEY=$1
NAME=${KEY%.*}
NOPASS=$NAME${2:-'-nopass.key'}

if [ -s $NOPASS ]; then
	echo "File '$NOPASS' exist!"
else
	openssl rsa -in $KEY -out $NOPASS
	[ "$?" -ne "0" ] && exit 2
	[ -f $NOPASS ] && echo "Done with '$NOPASS'!"
fi

echo ""

