#!/usr/bin/env bash

#打开执行过程显示
set -x
#显示设置环境变量 CMD_PATH当前脚本所在目录
export CMD_PATH=$(cd `dirname $0`; pwd)
export PROJECT_NAME="${CMD_PATH##*/}"

cd $CMD_PATH
env
pwd
whoami
df -h
free -m

pacman -Syyu --noconfirm

./tools/keyring.sh -a
./build.sh --bash-debug -c zstd --noloopmod --noconfirm --cleanup $GITHUB_REF_NAME
./5.sf.upload.sh
