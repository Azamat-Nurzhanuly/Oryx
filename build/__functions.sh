#!/bin/bash
# --------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT license.
# --------------------------------------------------------------------------------------------

# Folder structure is used to decide the tag name
# For example, if a Dockerfile is located at "images/runtime/node/10.1.0/Dockerfile",
# then the tag name would be 'node:10.1.0' (i.e. the path between 'runtime' and 'Dockerfile' segments)
# Additionally, if a os type such as debian-bullseye is passed in, we append the os type to the tag as well like
# node:10.1.0-debian-bullseye
function getTagName()
{
	if [ ! -d $1 ]
	then
		echo "Directory '$1' does not exist."
		return 1
	fi

	osTypeSuffix=""
	if [ ! -z $2 ]
	then
		osTypeSuffix="-$2"
	fi

	local replacedPath="$RUNTIME_IMAGES_SRC_DIR/"
	echo "Runtime Image Source Directory: "$RUNTIME_IMAGES_SRC_DIR
	local remainderPath="${1//$replacedPath/}"
	tagNameFile="$RUNTIME_IMAGES_SRC_DIR/$remainderPath/tag.txt"
	
	if [ -f "$tagNameFile" ]
	then
		getTagName_result=$(cat $tagNameFile)
		echo "tagname for "$replacedPath" is :"$getTagName_result
		return 0
	fi

	local slashChar="/"
	getTagName_result="${remainderPath//$slashChar/":"}$osTypeSuffix"
	return 0
}

function dockerCleanupIfRequested()
{
	if [ "$DOCKER_SYSTEM_PRUNE" == "true" ]
	then
		echo "Running 'docker system prune -f'"
		docker system prune -f
	else
		echo "Skipping 'docker system prune -f'"
	fi
}

function execAllGenerateDockerfiles()
{
	runtimeImagesSourceDir="$1"
	runtimeGenerateDockerFileScriptName="$2"
	runtimeImageDebianFlavor=$3

	echo "runtime image type '$3'"
	echo "runtimeGenerateDockerFileScriptName '$2'"

	generateDockerfiles=$(find $runtimeImagesSourceDir -type f -name $runtimeGenerateDockerFileScriptName)
	if [ -z "$generateDockerfiles" ]
	then
		echo "Couldn't find any '$runtimeGenerateDockerFileScriptName' under '$runtimeImagesSourceDir' and its sub-directories."
	fi

	for generateDockerFile in $generateDockerfiles; do
		echo
		echo "Executing '$generateDockerFile'..."
		echo
		eval "$(echo "$generateDockerFile $runtimeImageDebianFlavor")"
	done
}

function showDockerImageSizes()
{
	docker system df -v
}

function shouldStageRuntimeVersion()
{
	platformName="$1"
	platformRuntimeVersion="$2"

	case $platformName in
	'dotnet'|'dotnetcore')
		if [[ " ${DOTNETCORE_STAGING_RUNTIME_VERSIONS[*]} " =~ " ${platformRuntimeVersion} " ]]; then
			return 0
		fi
		;;
	'python')
		if [[ " ${PYTHON_STAGING_RUNTIME_VERSIONS[*]} " =~ " ${platformRuntimeVersion} " ]]; then
			return 0
		fi
		;;
	'node')
		if [[ " ${NODE_STAGING_RUNTIME_VERSIONS[*]} " =~ " ${platformRuntimeVersion} " ]]; then
			return 0
		fi
		;;
	'java')
		if [[ " ${JAVA_STAGING_RUNTIME_VERSIONS[*]} " =~ " ${platformRuntimeVersion} " ]]; then
			return 0
		fi
		;;
	'php')
		if [[ " ${PHP_STAGING_RUNTIME_VERSIONS[*]} " =~ " ${platformRuntimeVersion} " ]]; then
			return 0
		fi
		;;
	'hugo')
		if [[ " ${HUGO_STAGING_RUNTIME_VERSIONS[*]} " =~ " ${platformRuntimeVersion} " ]]; then
			return 0
		fi
		;;
	'ruby')
		if [[ " ${RUBY_STAGING_RUNTIME_VERSIONS[*]} " =~ " ${platformRuntimeVersion} " ]]; then
			return 0
		fi
		;;
	'golang')
		if [[ " ${GOLANG_STAGING_RUNTIME_VERSIONS[*]} " =~ " ${platformRuntimeVersion} " ]]; then
			return 0
		fi
		;;
	*) 
		echo "Platform '$platformName' does not support staging."
		;;
	esac
	return 1
}

## this method checks if we need to pass the storage SAS token.
## it is mainly needed to further retrieve the zip file from the `appinsights.agent` container of the oryxsdksstaging storage.
function shouldPassStorageSasToken()
{
	platformName="$1"

	case $platformName in
	'dotnet'|'dotnetcore')
		echo "For Platform '$platformName', the image needs the token as secret."
		return 0
		;;
	*)
	esac
	return 1
}