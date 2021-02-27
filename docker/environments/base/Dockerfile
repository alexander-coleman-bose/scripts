# Base Image
#
# This images extends ubuntu:latest.
#
# This image contains the following:
#   git
#   git-lfs
#   python3.6
#   python3-pip
#
#   Command-line utilities
#       ca-certificates
#       curl
#       jq
#       rsync
#
#   Python packages
#       pycobertura==0.10.5
#       setuptools

ARG REPO_VERSION="dev"
FROM ubuntu:latest AS BASE
# LABEL maintainer.name="" \
#       maintainers.email="" \
LABEL description="Base Image" \
      version=${REPO_VERSION}

# Set the locale to "Computer English" UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Set python to point to python3 and pip to pip3.
RUN ln -s /usr/bin/python3.6 /usr/bin/python \
 && ln -s /usr/bin/pip3 /usr/bin/pip

# Install the desired packages.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        git-lfs \
        jq \
        python3.6 \
        python3-pip \
        rsync \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set default global git config settings. Cannot be empty for use with Jenkins
RUN git config --global user.email "DoNotReply@example.com" \
 && git config --global user.name "Base Image"

# Install Python packages, update pip
COPY requirements.txt /requirements.txt
RUN pip install setuptools
RUN pip install -U pip
RUN pip install -r /requirements.txt
