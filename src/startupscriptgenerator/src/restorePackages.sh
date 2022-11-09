#!/bin/bash
# --------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT license.
# --------------------------------------------------------------------------------------------

declare -r WORKSPACE_DIR=$( cd $( dirname "$0" ) && cd .. && pwd )

echo "Restoring packages..."

# Check if 'dep' is installed
# EXIT_CODE=0
# which dep > /dev/null 2>&1 || EXIT_CODE=$?
# if [ $EXIT_CODE != 0 ]; then
#     echo "Installing dep..."
#     go get -u github.com/golang/dep/cmd/dep
#     # Delete the dep sources so that we do not use it when running tests etc.
#     rm -rf $WORKSPACE_DIR/src/github.com/golang/dep
# fi

goModFileName="go.mod"
for pkgDir in $WORKSPACE_DIR/src/* ; do
    if [ -d $pkgDir ]; then
        if [ -f "$pkgDir/$goModFileName" ]; then
            echo "Running './build.sh ${pkgDir#'/go/src/'} ${pkgDir#'/go/src/'}' under '$pkgDir'..."
            ./build.sh ${pkgDir#"/go/src/"} ${pkgDir#"/go/src/"}
        else
            echo "Cound not find '$goModFileName' under '$pkgDir'. Not running 'build.sh'"
        fi
    fi
done