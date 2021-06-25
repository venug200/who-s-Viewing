#!/bin/bash

mkdir deployTemp -p

while [ ! -n "$ORG_NAME"  ] 
do
	echo "Please enter target environment name"
	read ORG_NAME
done
echo ""
while [ ! -n "$CHECK_ONLY"  ] 
do
	echo "Check only? Y/N: "
	read CHECK_ONLY
done
echo ""
while [ ! -n "$RUN_TEST_CLASS"  ] 
do
	echo "Run Test Classes? Y/N: "
	read RUN_TEST_CLASS
done
echo ""

LAST_TAG=`git describe --tags --abbrev=0`
while [ ! -n "$TAG"  ] 
do
    
	echo "Last deployment tag name ($LAST_TAG): (y or type the tag) "
	read TAG
done

if [[ $TAG == "y" || $TAG == "Y" ]]; then
    TAG=$LAST_TAG
fi
echo $TAG

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
echo $COMMAND
bash -c $COMMAND

echo ""

rm -r deployTemp/*
IFS=$ifsBackup

