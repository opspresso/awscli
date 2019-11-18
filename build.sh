#!/bin/bash

OS_NAME="$(uname | awk '{print tolower($0)}')"

SHELL_DIR=$(dirname $0)

REPOSITORY=${GITHUB_REPOSITORY}

USERNAME=${GITHUB_ACTOR}
REPONAME=$(echo "${REPOSITORY}" | cut -d'/' -f2)

REPOPATH="aws/aws-cli"

NOW=
NEW=

################################################################################

# command -v tput > /dev/null && TPUT=true
TPUT=

_echo() {
    if [ "${TPUT}" != "" ] && [ "$2" != "" ]; then
        echo -e "$(tput setaf $2)$1$(tput sgr0)"
    else
        echo -e "$1"
    fi
}

_result() {
    echo
    _echo "# $@" 4
}

_command() {
    echo
    _echo "$ $@" 3
}

_success() {
    echo
    _echo "+ $@" 2
    exit 0
}

_error() {
    echo
    _echo "- $@" 1
    exit 1
}

_replace() {
    if [ "${OS_NAME}" == "darwin" ]; then
        sed -i "" -e "$1" $2
    else
        sed -i -e "$1" $2
    fi
}

################################################################################

_prepare() {
    # target
    mkdir -p ${SHELL_DIR}/target/publish

    # 755
    find ./** | grep [.]sh | xargs chmod 755
}

_pickup() {
    pushd ${SHELL_DIR}/target
    curl -sLO https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
    unzip awscli-bundle.zip
    popd

    VERSION=$(ls ${SHELL_DIR}/target/awscli-bundle/packages/ | grep awscli | sed 's/awscli-//' | sed 's/.tar.gz//' | xargs)

    if [ -z "${VERSION}" ]; then
        _error "Not found new version."
    fi

    _result "_pickup ${VERSION}"
}

_updated() {
    printf "${VERSION}" > ${SHELL_DIR}/VERSION
    printf "${VERSION}" > ${SHELL_DIR}/target/commit_message

    _replace "s/ENV VERSION .*/ENV VERSION ${VERSION}/g" ${SHELL_DIR}/Dockerfile
    _replace "s/ENV VERSION .*/ENV VERSION ${VERSION}/g" ${SHELL_DIR}/README.md

    cat <<EOF > ${SHELL_DIR}/target/slack_message.json
{
    "username": "${USERNAME}",
    "attachments": [{
        "color": "good",
        "footer": "<https://github.com/${REPOSITORY}/releases/tag/${VERSION}|${REPOSITORY}>",
        "footer_icon": "https://repo.opspresso.com/favicon/github.png",
        "title": "${REPONAME}",
        "text": "\`${VERSION}\`"
    }]
}
EOF

    _result "_updated ${VERSION}"
}

_latest() {
    COUNT=$(echo ${VERSION} | grep '-' | wc -l | xargs)

    if [ "x${COUNT}" != "x0" ]; then
        _success "_latest New version has '-'."
    fi

    LATEST=$(cat ${SHELL_DIR}/LATEST | xargs)

    BIGGER=$(echo -e "${VERSION}\n${LATEST}" | sort -V -r | head -1)

    if [ "${BIGGER}" == "${LATEST}" ]; then
        _success "_latest ${VERSION} <= ${LATEST}"
    fi

    printf "${VERSION}" > ${SHELL_DIR}/LATEST
    printf "${VERSION}" > ${SHELL_DIR}/target/publish/${REPONAME}

    _replace "s/ENV LATEST .*/ENV LATEST ${VERSION}/g" ${SHELL_DIR}/README.md

    _result "_latest ${VERSION}"
}

_build() {
    _prepare
    _pickup
    _updated
    _latest
}

################################################################################

_build
