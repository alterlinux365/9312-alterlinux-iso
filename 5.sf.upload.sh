#!/usr/bin/env bash

#打开执行过程显示
set -x
#显示设置环境变量 CMD_PATH当前脚本所在目录
export CMD_PATH=$(cd `dirname $0`; pwd)
export PROJECT_NAME="${CMD_PATH##*/}"

cd $CMD_PATH
mkdir -p ~/.ssh/
echo "$MY_SF_SSH" > ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519
touch ~/.ssh/known_hosts
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "frs.sourceforge.net"
ssh-keyscan "frs.sourceforge.net" >> ~/.ssh/known_hosts
rsync -avzP  ./out/  gnuhub@frs.sourceforge.net:/home/frs/project/alterlinux365/$GITHUB_REF_NAME/$GITHUB_RUN_NUMBER/
