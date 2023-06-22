#!/bin/bash

set -e

TAG=$(git describe --tags)

git checkout master

rm -rf service.lt2http

sudo -S true

# Install Python dependencies
pip3 install -r requirements.txt

# Run Python linting
python3 -m flake8
./scripts/xgettext.sh

# Compile zip artifacts
make

# Run artifact uploads if we are on the tag
if [[ $TAG != *-* ]]
then
    make upload
fi
