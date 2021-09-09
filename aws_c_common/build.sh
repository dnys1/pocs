#!/bin/bash

dart pub get

mkdir -p build
pushd build
cmake -DBUILD_SHARED_LIBS=ON ../aws-c-common
cmake --build .
popd

dart run ffigen --config=ffigen.yaml