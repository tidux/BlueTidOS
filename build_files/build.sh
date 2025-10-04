#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux mosh emacs git-email postfix


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

### copy shit over from the NNCPNet base container we're using instead of Scratch

# NNCP binaries
cp -a /ctx/usr/local/bin/nncp* /usr/local/bin/

# fix systemd configs to point to /usr/local instead of /opt
cp -a /ctx/etc/systemd/system/nncp* /usr/etc/systemd/system
for NNCPFILE in /usr/etc/systemd/system/nncp*; do
    sed -i 's/opt\/nncpnet/usr\/local/g' $NNCPFILE
done

# NNCPNet files install
cp -a /ctx/opt/nncpnet/bin/* /usr/local/bin
mkdir /usr/local/etc/nncpnet
cp -a /ctx/opt/nncpnet/etc/* /usr/local/etc/nncpnet
rm /usr/local/etc/nncpnet/cfg/selfprv /usr/local/etc/nncpnet/cfg/selfpub
sed -i 's/opt\/nncpnet/usr\/local/g' /usr/local/bin/nodelist-freq
mkdir /usr/local/etc/nncp-cfg.active
chown nncp:nncp /usr/local/etc/nncp-cfg.active
ln -s /usr/local/etc/nncp-cfg.active /usr/local/etc/nncp-cfg
# This is weird but symlinking a directory to a .hjson name lets NNCP parse it correctly
ln -s /usr/local/etc/nncp-cfg /usr/local/etc/nncp.hjson

systemctl daemon-reload && systemctl enable nncpnet-freq-nodelist.timer
