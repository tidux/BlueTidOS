#!/bin/bash

set -x
set -eo pipefail

# Create a new config

nncp-cfgnew > /tmp/t
nncp-cfgdir -cfg /tmp/t -dump /usr/local/etc/nncp-cfg-tmpl

sudo chown -R nncp:nncp /usr/local/etc/nncp-cfg-tmpl
sudo chmod 0700 /usr/local/etc/cfg/selfprv

sudo rm -r /tmp/t /usr/local/etc/nncp-cfg-tmpl/self/* \
	/usr/local/etc/nncp-cfg-tmpl/neigh/self/* \
	/usr/local/etc/nncp-cfg-tmpl/mcd*


echo $(id -u) | sudo tee /usr/local/etc/localuser-uid
echo $(whoami) | sudo tee /usr/local/etc/localuser-name
echo $(grep ^$(whoami) /etc/passwd | cut -d: -f5 ) | sudo tee /usr/local/etc/localuser-comment
echo none | sudo tee /usr/local/etc/bridge_mode
echo nnvax | sudo tee /usr/local/etc/bridge_host

# This was runtime in nncpnet-docker, now we want to run it deliberately
if [[ -f /etc/nncpnet.env  ]]; then
	# do envmerge stuff
	pass
else
	echo "Error: missing env file!"
fi
