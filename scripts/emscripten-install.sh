#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo $DIR/../external/emsdk

if which emcmake >/dev/null; then
    echo emsdk exists in path
elif [[ -d $DIR/../external/emsdk ]]; then
    echo emsdk exists in a folder
    source $DIR/../external/emsdk/emsdk_env.sh
    emsdk install latest
    emsdk activate latest
    source $DIR/../external/emsdk/emsdk_env.sh
else
    echo installing emsdk
    git clone https://github.com/emscripten-core/emsdk.git $DIR/../external/emsdk/
    source $DIR/../external/emsdk/emsdk_env.sh
    emsdk install latest
    emsdk activate latest
    source $DIR/../external/emsdk/emsdk_env.sh
fi

