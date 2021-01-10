#!/usr/bin/env bash

function makewalk() {
    # Settings --------------------

    readonly separator="-"

    # Utilities --------------------

    function join_by_separator() {
        local IFS=$separator; echo "$*";
    }
    readonly -f join_by_separator &>/dev/null

    function echo_and_run() {
        echo "\$ $*"; eval $*;
    }
    readonly -f echo_and_run &>/dev/null

    # Main --------------------

    readonly fullpath=`join_by_separator "$@"`
    readonly filename=`basename $fullpath`
    readonly dirpath=`dirname $fullpath`

    echo_and_run "mkdir -p $dirpath"
    echo_and_run "cd $dirpath"
}
readonly -f makewalk &>/dev/null
