# Introduction
This repository holds the `myrepos` and `vcsh` configuration I use to manage my home directory across multiple machines.  

Richard Hartmann’s [vcsh](https://github.com/RichiH/vcsh) allows you to manage all your dotfiles in Git without the need to set up numerous symlinks.  [myrepos](https://github.com/joeyh/myrepos) (often simply referred to as `mr`) by Joey Hess allows you to centrally manage a set of repositories. Combining these tools, I am able to store my various dotfiles, application settings, and useful scripts in separate repositories and pull them together to quickly set up my home directory on a new computer and keep them in sync across various machines.

# Repositories
I use `myrepos` to pull a collection of repos (both mine and external):

**External Repositories**
* [vcsh](https://github.com/RichiH/vcsh) gets the latest code directly from upstream.
* [myrepos](https://github.com/joeyh/myrepos) gets the latest code directly from upstream.
* [nano-syntax](https://github.com/scopatz/nanorc) has a great compilation of syntax highlighting for nano
* [docker-gc](https://github.com/spotify/docker-gc) is a tool from Spotify to remove old docker containers and images.

**My Repositories**
* [vcsh-root](https://github.com/liquidstate/vcsh-root) is this repository, which holds my `vcsh` and `myrepos` config.
* [dotfiles](https://github.com/liquidstate/dotfiles) is my repo that contains various dotfiles, settings and scripts for my home directory.  I'll eventually split this off into a few separate repos I think.

# Setting up a new computer
I've written a handy bootstrap script to make the process of setting up a new computer as easy as possible.  All you need is `wget` or `curl` installed to fetch files from the web, and at least version 1.9 of `git`.  The bootstrap script will check that the dependencies are in place; download a temporary copy of `vcsh` and `myrepos`; clone my [vcsh-root](https://github.com/liquidstate/vcsh-root) repository which contains my `myrepos` config; and then call `mr update` to then pull in all the repositories I want.

* `yum -y install wget`
* You will need `git` (at least version 1.9).  Use [this script](https://raw.githubusercontent.com/liquidstate/vcsh-root/bootstrap/installgit19.sh) to install on CentOS/RHEL 7.
* `wget https://raw.githubusercontent.com/liquidstate/vcsh-root/bootstrap/bootstrap.sh`
* `chmod +x bootstrap.sh`
* `./bootstrap.sh`

# Management
### Make sure a machine is up to date
* `cd $HOME; mr update`

### Add a new file to version control
* `track <repo> <file(s)>`

### Stop version controlling a file
* `untrack <file(s)>`

### List the files in the current directory that are version controlled
* `tracked`

### List the files in the current directory that are **not** version controlled
* `untracked`

### Commit and push any changes up to the upstream repositories
* `pushtracked`
