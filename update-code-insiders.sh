#!/bin/bash

get_latest() {
    update="https://go.microsoft.com/fwlink/?LinkId=723968"
    latest=$(curl -sIL ${update} | grep -i '^Location: ' | tail -n 1 | cut -d' ' -f2 | tr -dc "[:print:]")
    outpath=$(dirname $(readlink -f ${0}))/$(basename ${latest} | cut -d. -f1)
    extension=$(basename ${latest} | awk 'BEGIN { FS="." } { print $(NF) }')

    mkdir -vp ${outpath}
    echo GET ${latest}
    echo $(curl -s ${latest} | tar -C ${outpath} -zxv --no-same-owner --strip-components=1 | wc -l) files extracted to ${outpath}
}

add_link() {
    latest=$(find $(dirname $(readlink -f ${0})) | grep 'bin/code-insiders$' | sort -rV | head -n 1)
    latest=$(readlink -f $(dirname ${latest})/..)

    ln -s ${latest} current

    desktopfile=$(dirname $(readlink -f ${0}))/code-insiders.desktop
    
    if [ -f ${desktopfile} ]; then
        ln -sfv ${desktopfile} ~/.local/share/applications/code-insiders.desktop
    fi    
}

get_latest
add_link
