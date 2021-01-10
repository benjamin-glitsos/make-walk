#!/usr/bin/env bash

declare -rf makewalk() {
    # Settings --------------------

    declare -r separator="-"
    declare -r opener="vimer"

    # Utilities --------------------

    declare -rf join_by_separator() {
        declare IFS=$separator; echo "$*";
    }

    declare -rf echo_and_run() {
        echo "\$ $*"; eval $*;
    }

    # Main --------------------

    declare -r fullpath=`join_by_separator "$@"`
    declare -r filename=`basename $fullpath`
    declare -r dirpath=`dirname $fullpath`

    echo_and_run "mkdir -p $dirpath"
    echo_and_run "cd $dirpath"
    echo_and_run "touch $filename"
    echo_and_run "$opener $filename"
}
