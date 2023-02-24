#!/bin/sh

. $HOME/.profile

IXOPS_LOG=".ixops.log"
rm -rf ${IXOPS_LOG}
APT_GET_UPDATE=true

GO_VERSION="1.20"

check_exec() {
    # this function executes a given command with its args and logs the output indented
    # with 4 spaces in log file instead of logging to stdout;
    # proper error code is returned in case of success or failure
    log "Checking '${@}'" | tee -a ${IXOPS_LOG} > /dev/null
    eval ${@} 2>&1 | sed 's/^/    /' | tee -a ${IXOPS_LOG} > /dev/null && return 0 || return 1
}

apt_update() {
    log "Checking if apt-get update is needed"
    if [ "${APT_GET_UPDATE}" = "true" ]
    then
        check_exec sudo apt-get update
        APT_GET_UPDATE=false
    fi
}

apt_install() {
    log "Installing ${1} ..."
    apt_update \
    && check_exec sudo apt-get install -y --no-install-recommends
}

apt_install_curl() {
    check_exec curl --version && return
    apt_install curl
}

apt_install_vim() {
    check_exec dpkg -s vim && return
    apt_install vim
}

apt_install_git() {
    check_exec git version && return
    apt_install git
}

apt_install_lsb_release() {
    check_exec lsb_release -v && return
    apt_install lsb_release
}

apt_install_gnupg() {
    check_exec gpg -k && return
    apt_install gnupg
}

apt_install_ca_certs() {
    check_exec dpkg -s ca-certificates && return
    apt_install ca-certificates
}

apt_install_pkgs() {
    check_exec uname -a \| grep -i linux || return 0
    inf "Installing apt packages"
    apt_install_curl \
    && apt_install_vim \
    && apt_install_git \
    && apt_install_lsb_release \
    && apt_install_gnupg \
    && apt_install_ca_certs
}

go_tar_link() {
    https://dl.google.com/go/go${1}.linux-amd64.tar.gz
}

get_go() {
    check_exec go version && return
    inf "Installing Go ${GO_VERSION} ..."
    # install golang per https://golang.org/doc/install#tarball
    curl -kL $(go_tar_link ${GO_VERSION}) | sudo tar -C /usr/local/ -xzf - \
    && echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.profile \
    && . $HOME/.profile \
    && go version
}

inf() {
    echo "${2}\033[1;32m${1}\033[0m${2}"
}

wrn() {
    echo "${2}\033[1;33m${1}\033[0m${2}"
}

err() {
    echo "\n\033[1;31m${1}\033[0m\n"
    if [ ! -z ${2} ]
    then
        exit ${2}
    fi
}

log() {
    echo "$(date +'[%d-%m-%Y %H:%M:%S LOG]') ${@}"
}

case $1 in
    ""  )
        err "usage: $0 [name of any function in script]" 1
    ;;
    *   )
        # shift positional arguments so that arg 2 becomes arg 1, etc.
        file=${0}
        cmd=${1}
        shift 1
        ${cmd} ${@} 2>&1 | tee -a ${IXOPS_LOG} || err "failed executing '${file} ${cmd} ${@}'"
    ;;
esac
