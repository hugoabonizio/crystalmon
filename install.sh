#!/usr/bin/env bash
pushd
cd /tmp
git clone --depth 1 https://github.com/hugoabonizio/crystalmon crystalmon && cd crystalmon
make install
popd
