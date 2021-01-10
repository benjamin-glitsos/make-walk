#!/bin/bash

# Settings --------------------

readonly separator="-"

# Utilities --------------------

function join_by_separator() {
    local IFS=$separator; echo "$*";
}

function echo_and_run() {
    echo "$*" ; "$@" ;
}

# Main --------------------

readonly fullpath=`join_by_separator "$@"`
readonly filename=`basename $fullpath`
readonly dirpath=`dirname $fullpath`

echo $filename
echo $dirpath
