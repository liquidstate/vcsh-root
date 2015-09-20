#!/bin/sh
set -e

################################################################################
## bootstrap.sh                            Bryan Ross <bryan@liquidstate.net> ##
##                                                                            ##
## Bootstrap version-controlled dotfiles using 'myrepos' and 'vcsh'.          ##
## Find out more at: https://github.com/liquidstate/vcsh-root                 ##
##                                                                            ##
################################################################################

################################################################################
## Configuration                                                              ##
################################################################################
## url where we can RAW copies of 'mr' (myrepos) and 'vcsh'
vcsh_bootstrap='https://raw.githubusercontent.com/liquidstate/vcsh-root/bootstrap'

## url to where we can find our vcsh and myrepos configuration
vcsh_root='git@github.com:liquidstate/vcsh-root.git'


################################################################################
## Code                                                                       ##
################################################################################
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

# get version of GNU tool (eg. "toolversion grep 2.1 || echo 'grep is too old'")
toolversion() {
    local prog="$1" minversion="$2" version

    version=$($prog --version | grep $prog | grep -oE '[0-9]+\.[0-9\.]+')

    if [ "$#" -gt 1 ]; then
        # compare versions
        awk -vv1="$version" -vv2="$minversion" 'BEGIN {
            split(v1, a, /\./); split(v2, b, /\./);
            if (a[1] == b[1]) {
                exit (a[2] >= b[2]) ? 0 : 1
            }
            else {
                exit (a[1] >= b[1]) ? 0 : 1
            }
        }'
    else
        # just report the version
        echo $version
    fi
}

# Something odd has happened
[ -z "$HOME" ] && fatal '$HOME not set; exiting' 1

# We need SSH keys to talk to our upstream repositories
# [ ! -f "$HOME/.ssh/id_rsa" ] && [ ! -f "$HOME/.ssh/id_dsa" ] && fatal 'SSH key pair not available; exiting' 1

# vcsh requires git 1.9 upwards... (https://github.com/RichiH/vcsh/issues/137)
command -v git >/dev/null || fatal 'Unable to find git' 1
toolversion git 1.9 || fatal "Sorry, vcsh requires git 1.9+. You have $(toolversion git); exiting" 1

# We'll store some bootstrap stuff in here
[ ! -d "$HOME/tmp" ] && mkdir "$HOME/tmp"
cd "$HOME/tmp"

# Find curl or wget
[ -z "$HTTP_GET" ] && command -v wget >/dev/null && HTTP_GET='wget -N -nv'
[ -z "$HTTP_GET" ] && command -c curl >/dev/null && HTTP_GET='curl -s -S -O'
[ -z "$HTTP_GET" ] && fatal 'Unable to find wget or curl' 1

info "bootstrapping vcsh from ${vcsh_bootstrap}/vcsh..."
$HTTP_GET $vcsh_bootstrap/vcsh

info "bootstrapping myrepos from ${vcsh_bootstrap}/mr..."
$HTTP_GET $vcsh_bootstrap/mr

chmod 755 mr vcsh

cd "$HOME"

export PATH="$HOME/tmp:$PATH"

# Clone the root repo, containing the mr and vcsh configuration
info "configuring ${vcsh_root}..."
[ ! -d "$HOME/.config/vcsh/repo.d/mr.git" ] && vcsh clone $vcsh_root mr

# Fixup mr's working tree for the sparse checkout settings
vcsh mr read-tree -mu HEAD

info "pulling in content..."
[ ! -f "$HOME/.mrconfig" ] && fatal ".mrconfig file wasn't downloaded for some reason; exiting" 1
mr update

rm -rf "$HOME/tmp"
