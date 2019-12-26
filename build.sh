#!/bin/sh
cd `dirname $0`
mkdir build
cd build

git clone https://github.com/yuji-morita/android-doc-test.git && cd $(basename $_ .git)
tags=$(git tag)

docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material build -d docs

for tag in ${tags[@]}
do
    git clean -df . > /dev/null 2>&1
    git checkout refs/tags/$tag > /dev/null 2>&1
    docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material build -d docs/$tag
done

rm -rf ../../docs
cp -r docs ../../

rm -rf ../../build