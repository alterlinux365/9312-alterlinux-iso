#!/usr/bin/env bash

set +x
export CMD_PATH=$(cd `dirname $0`; pwd)
export PROJECT_NAME="${CMD_PATH##*/}"
cd $CMD_PATH
cd channels
for c in `ls`
do
    
    if [ $c != "README.md" ];then
        echo $c
        if [ $c != "xfce" ];then
            git checkout $c
            git merge xfce 
            p2
        fi
    fi
done