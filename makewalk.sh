#!/bin/bash

function join_by_separator() {
    local IFS="-"; echo "$*";
}

fullpath=`join_by_separator "$@"`
filename=`basename $fullpath`
dirpath=`dirname $fullpath`

echo $filename
echo $dirpath
