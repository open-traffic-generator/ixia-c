#!/bin/sh

HOME_PROFILE="${HOME}/.profile"
HOME_LOCAL="${HOME}/.local"
HOME_LOCAL_BIN="${HOME}/.local/bin"
HOME_IXOPS="${HOME}/.ixops"
IXOPS_LOG="${HOME_IXOPS}/ixops.log"

source_profile() {
    . ${HOME_PROFILE}
}

init() {
    mkdir -p ${HOME_LOCAL_BIN}
    mkdir -p ${HOME_IXOPS}
    rm -rf ${IXOPS_LOG}
    source_profile
}

init


APT_GET_UPDATE=true
GO_VERSION="1.20"


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

check_exec() {
    # this function executes a given command with its args and logs the output indented
    # with 4 spaces in log file instead of logging to stdout;
    # proper error code is returned in case of success or failure
    log "Checking '${@}'" | tee -a ${IXOPS_LOG} > /dev/null
    out=$(eval ${@} 2>&1)
    err=$?
    echo "${out}" | sed 's/^/    /' | tee -a ${IXOPS_LOG} > /dev/null
    [ "${err}" = "0" ] && return 0 || return 1
}

on_linux() {
    check_exec uname -a \| grep -i linux || return 1
}

on_ubuntu() {
    on_linux || return 1
    check_exec grep Ubuntu /etc/os-release || return 1
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
    on_ubuntu || err "apt-get installation is only supported on Ubuntu" 1
    inf "Installing apt packages"
    apt_install_curl \
    && apt_install_vim \
    && apt_install_git \
    && apt_install_lsb_release \
    && apt_install_gnupg \
    && apt_install_ca_certs
}

go_tar_link() {
    go_version="${1}"
    [ -z "${go_version}" ] && err "go version not provided when calling go_tar_link" 1
    case "$(arch)" in
        "x86_64"  )
            go_arch="amd64"
        ;;
        "aarch64"  )
            go_arch="arm64"
        ;;
        "arm64"  )
            go_arch="arm64"
        ;;
        *   )
            err "unsupported architecture for go tar link: $(arch)" 1
        ;;
    esac

    echo "https://dl.google.com/go/go${go_version}.linux-${go_arch}.tar.gz"
}

get_go() {
    check_exec go version && return
    on_linux || err "Go installation is only supported on Linux-based OS" 1

    [ -z "${1}" ] && go_version="${GO_VERSION}" || go_version="${1}"

    inf "Installing Go ${go_version} ..."
    # install golang per https://golang.org/doc/install#tarball
    curl -kL $(go_tar_link ${go_version}) | tar -C ${HOME_LOCAL} -xzf - \
    && echo 'export PATH=$PATH:$HOME/.local/go/bin:$HOME/go/bin' >> ${HOME}/.profile \
    && source_profile \
    && check_exec go version || err "Failed installing Go" 1
}

get_docker() {
    check_exec docker -v && return
    inf "Installing Docker ..."
}

common_install() {
    apt_install_pkgs \
    && get_go \
    && get_docker
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
