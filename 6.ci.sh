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

cp -fv ./pacman.conf1 /etc/pacman.conf
cp -fv ./mirrorlist /etc/pacman.d/
pacman -Syyu --noconfirm

pacman-key --init
pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key FBA220DFC880C036
pacman --noconfirm -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

pacman -Syyu --noconfirm git sudo python3 base-devel cmake ninja qt5-base archiso arch-install-scripts pyalpm cmake
pacman -Syyu --noconfirm procps zsh wget git make sudo python3 base-devel cmake ninja qt5-base arch-install-scripts pyalpm squashfs-tools libisoburn dosfstools openssh rsync

cp -fv ./pacman.conf2 /etc/pacman.conf
pacman -Syyu --noconfirm

./tools/keyring.sh -a
./build.sh --bash-debug -c zstd --noloopmod --noconfirm --cleanup $GITHUB_REF_NAME
./5.sf.upload.sh
