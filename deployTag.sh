#!/bin/bash

mkdir deployTemp -p

while [ ! -n "$ORG_NAME"  ] 
do
	echo -e "\e[35mPlease enter target environment name \e[0m"
	read ORG_NAME
done
echo ""
while [ ! -n "$CHECK_ONLY"  ] 
do
	echo -e "\e[35mCheck only? Y/N:  \e[0m"
	read CHECK_ONLY
done
echo ""
while [ ! -n "$RUN_TEST_CLASS"  ] 
do
	echo -e "\e[35mRun Test Classes? Y/N: \e[0m"
	read RUN_TEST_CLASS
done
echo ""

LAST_TAG=`git describe --tags --abbrev=0`
while [ ! -n "$TAG"  ] 
do
    
	echo -e "\e[35mLast deployment tag name (\e[0m\e[100m$LAST_TAG\e[0m\e[35m): (y or type the tag)\e[0m"
	read TAG
done
echo ""
while [ ! -n "$OPEN_ORG"  ] 
do
	echo -e "\e[35mOpen Deployment Status page? Y/N\e[0m"
	read OPEN_ORG
done
echo ""

if [[ $TAG == "y" || $TAG == "Y" ]]; then
    TAG=$LAST_TAG
fi
echo
echo -e "\e[34mSelected tag \e[0m\e[100m$TAG\e[0m"

echo ""

ifsBackup=$IFS
IFS=$'\n'
declare -a metaFile
for line in `git log --name-status ${TAG}..HEAD --no-renames --diff-filter=d | grep veygo-app/`
do
    line=${line:2}
    if [[ $line == veygo-app/* ]]; then
        if [[ $line == *aura/* || $line == *lwc/* ]]; then
            AURA_COMPONENT_DIR=$(dirname $line)
            echo adding to deployment - dir: $AURA_COMPONENT_DIR
            cp -r --parents $AURA_COMPONENT_DIR deployTemp/
        elif [[ $line == *-cs/* ]]; then
            TRANSLATE_COMPONENT_DIR=$(dirname $line)
            echo adding to deployment - dir: $TRANSLATE_COMPONENT_DIR
            cp -r --parents $TRANSLATE_COMPONENT_DIR deployTemp/
        else
            cp --parents $line deployTemp/
            echo adding to deployment: $line
            cp --parents "$line-meta.xml" deployTemp/ 2>deployTemp/null
        fi
    fi
done
echo ""
COMMAND="sfdx force:source:deploy -p deployTemp/veygo-app/ -u $ORG_NAME "
if [[ $CHECK_ONLY == "y" || $CHECK_ONLY == "Y" ]]; then
    COMMAND="$COMMAND--checkonly  "    
fi
if [[ $RUN_TEST_CLASS == "y" || $RUN_TEST_CLASS == "Y" ]]; then
    COMMAND="$COMMAND--testlevel RunLocalTests "
fi
echo -e "\e[1m\e[32m"
echo $COMMAND
echo -e "\e[0m"
if [[ $OPEN_ORG == "y" || $OPEN_ORG == "Y" ]]; then
    sfdx force:org:open -u $ORG_NAME -p lightning/setup/DeployStatus/home
fi

bash -c $COMMAND



rm -r deployTemp/*
IFS=$ifsBackup

