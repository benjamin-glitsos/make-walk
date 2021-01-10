#!/bin/bash

readonly separator="-"

function join_by_separator() {
    local IFS=$separator; echo "$*";
}

readonly fullpath=`join_by_separator "$@"`
readonly filename=`basename $fullpath`
readonly dirpath=`dirname $fullpath`

echo $filename
echo $dirpath
