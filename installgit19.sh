#!/bin/bash

SELF=$(basename $0)

# Pretty print function to show info
function info() {
    col_green="\e[1;32m";
    col_white="\e[1;37m";
    col_reset="\e[0m";

    echo -en "$col_green[info] $col_white"
    echo "$@"
    echo -en "$col_reset"
}

# Pretty print function to show errors
function fatal() {
    col_red="\e[1;31m";
    col_white="\e[1;37m";
    col_reset="\e[0m";

    echo -en "$col_red[error] $col_white"
    echo "$@"
    echo -en "$col_reset"
    exit $2
}

# We need to run as root
[ $(whoami) != 'root' ] && fatal "you must be root to install software; exiting"

grep -q 'Linux release 7' /etc/redhat-release || fatal "Only RHEL/CentOS 7.x is supported; exiting"

# Install curl
info "Installing 'curl'..."
yum -y install curl

# Install Software Collections
info "Installing Software Collection utilities (scl-utils)..."
yum -y install scl-utils

# Configure Git 1.9 Software Collection
info "Configuring git19 repository at '/etc/yum.repos.d/rhscl-git19-el7-epel-7.repo'..."
cat <<EOF > /etc/yum.repos.d/rhscl-git19-el7-epel-7.repo
[rhscl-git19-el7]
name=Copr repo for git19-el7 owned by rhscl
baseurl=https://copr-be.cloud.fedoraproject.org/results/rhscl/git19-el7/epel-7-$(uname -i)/
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/rhscl/git19-el7/pubkey.gpg
enabled=1
enabled_metadata=1
EOF

# Install Git 1.9
info "Installing 'git19' from Software Collection..."
yum -y install git19

# Enable it
echo
info "git 1.9 installed at /opt/rh/git19/root/usr/bin/git"
info " "
info "use 'source /opt/rh/git19/enable' to enable it in your shell"
echo
source /opt/rh/git19/enable
