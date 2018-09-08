#!/bin/bash

USERNAME=${1}
REPONAME=${2}
GITHUB_TOKEN=${3}

mkdir -p target

pushd target
curl -sLO https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
unzip awscli-bundle.zip
popd

NOW=$(cat ./VERSION | xargs)
NEW=$(ls target/awscli-bundle/packages/ | grep awscli | sed 's/awscli-//' | sed 's/.tar.gz//' | xargs)

printf '# %-10s %-10s %-10s\n' "${REPONAME}" "${NOW}" "${NEW}"

if [ "${NOW}" != "${NEW}" ]; then
    printf "${NEW}" > VERSION
    sed -i -e "s/ENV VERSION .*/ENV VERSION ${NEW}/g" Dockerfile

    if [ ! -z ${GITHUB_TOKEN} ]; then
        git config --global user.name "bot"
        git config --global user.email "ops@nalbam.com"

        git add --all
        git commit -m "${NEW}"
        git push -q https://${GITHUB_TOKEN}@github.com/${USERNAME}/${REPONAME}.git master

        echo "# git push github.com/${USERNAME}/${REPONAME} ${NEW}"

        git tag ${NEW}
        git push -q https://${GITHUB_TOKEN}@github.com/${USERNAME}/${REPONAME}.git ${NEW}
    fi
fi
