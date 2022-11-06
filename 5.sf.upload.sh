#!/usr/bin/env bash

#打开执行过程显示
set +x
#显示设置环境变量 CMD_PATH当前脚本所在目录
export CMD_PATH=$(cd `dirname $0`; pwd)
export PROJECT_NAME="${CMD_PATH##*/}"

cd $CMD_PATH
mkdir -p ~/.ssh/
echo "${MY_SF_SSH}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
cp -fv known_hosts ~/.ssh/known_hosts
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "frs.sourceforge.net"
ssh-keyscan "frs.sourceforge.net" >> ~/.ssh/known_hosts
cat ~/.ssh/known_hosts
ssh-agent bash
ssh-add
mkdir -p $GITHUB_REF_NAME
rsync -avzP -e "ssh -i  ~/.ssh/id_rsa" ./$GITHUB_REF_NAME/  gnuhub@frs.sourceforge.net:/home/frs/project/alterlinux365/$GITHUB_REF_NAME/
rsync -avzP -e "ssh -i  ~/.ssh/id_rsa" ./out/  gnuhub@frs.sourceforge.net:/home/frs/project/alterlinux365/$GITHUB_REF_NAME/$GITHUB_RUN_NUMBER/
