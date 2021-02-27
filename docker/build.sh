#!/usr/bin/env bash
# Script to build the docker images manually and bootstrap a build environment.
# Author: Alex Coleman

# Get the absolute path of the environments folder.
docker_images="$( cd "$( dirname "${BASH_SOURCE[0]}" )/environments" >/dev/null && pwd )"

this="build.sh"
project_name="environments"

################################################################################
# FUNCTIONS
################################################################################

echo_help () {
    echo "Usage: $this [OPTIONS] <IMAGES>"
    echo ""
    echo "This script builds the Docker images."
    echo ""
    echo "OPTIONS"
    echo "  -h|--help               Displays this help message"
    echo "  -a|--all                Builds all images in the docker-images directory"
    echo "  -p|--push [REGISTRY]    Pushes the built images to a registry; defaults to env DOCKER_REGISTRY"
    echo "  -v|--version VERSION    Tags the built images with a version; defaults to env REPO_VERSION"
    echo ""
    echo "IMAGES"
    echo "  base                Base image with Git, Python, jq, and curl."
    echo ""
    echo "ENVIRONMENT VARIABLES"
    echo "  DOCKER_REGISTRY     The container registry URL to push images to, overridden by REGISTRY"
    echo "  REPO_VERSION        Tags the built images with a version, overridden by VERSION"
    echo ""
}

build () {
    # Check to see if we have already built this image
    for image in "${built[@]}"; do
        if [ "$image" == "$1" ]; then
            return 0
        fi
    done

    # If we can't find the image context folder, error out of this function.
    image_context="$docker_images/$1"
    if [ ! -d "$image_context" ]; then
        echo "ERROR:$this: Cannot build $1, could not find $image_context directory." >&2
        return 1
    fi

    # Use VERSION to determine how to tag the docker image, then build it.
    if [ -z "$version" ]; then
        build_tag="$project_name:$1"
        docker build -t "$build_tag" "$image_context"
    else
        build_tag="$project_name:$1-$version"
        docker build -t "$build_tag" \
            --build-arg REPO_VERSION="$version" \
            --build-arg BASE_TAG="-$version" \
            "$image_context"
    fi
    echo "$this: built $build_tag"
    built+=("$1")

    if [ "$push" == "true" ]; then
        docker tag "$build_tag" "$registry/$build_tag"
        docker push "$registry/$build_tag"
    fi
}

################################################################################
# MAIN
################################################################################

# Handle inputs
if [[ $# -eq 0 ]]; then
    echo_help
    exit 0
fi
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            echo_help
            exit 0
            ;;

        -a|--all)
            build_all=true
            shift
            ;;

        -p|--push)
            if [ -z "$2" ] || [ "${2:0:1}" == "-" ]; then
                if [ -z "$DOCKER_REGISTRY" ]; then
                    echo "ERROR:$this: If --push is given without an argument, then DOCKER_REGISTRY must be set." >&2
                    exit 1
                else
                    registry="$DOCKER_REGISTRY"
                fi
            else
                registry="$2"
                shift
            fi
            push=true
            shift
            ;;

        -v|--version)
            if [ -z "$2" ] || [ "${2:0:1}" == "-" ]; then
                if [ -z "$REPO_VERSION" ]; then
                    echo "ERROR:$this: If --version is given without an argument, then REPO_VERSION must be set." >&2
                    exit 1
                else
                    version="$REPO_VERSION"
                fi
            else
                version="$2"
                shift
            fi
            shift
            ;;

        -*)
            echo "ERROR:$this: Unrecognized input $key." >&2
            exit 1
            ;;

        *)
            if [ ! -z "$build_all" ]; then
                echo "ERROR:$this: You cannot specify images to build with the --all option." >&2
                exit 1
            fi
            to_build+=("$key")
            shift
            ;;
    esac
done

if [ "$build_all" == "true" ]; then
    cd "$docker_images" || return
    for dir in *; do
        if [ -d "$dir" ]; then to_build+=("$dir"); fi
    done
fi

for image in "${to_build[@]}"; do
    build "$image"
done
