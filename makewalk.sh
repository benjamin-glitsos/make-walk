#!/usr/bin/env bash

declare -rf makewalk() {
    # Settings --------------------

    declare -r separator="-"
    declare -r opener="vimer"

    # Colous --------------------

    declare -r blue="\033[0;34m"
    declare -r purple="\033[0;35m"
    declare -r nocolor="\033[0m"

    # Utilities --------------------

    declare -rf join_by_separator() {
        declare IFS=$separator; echo "$*";
    }

    declare -rf echo_and_run() {
        declare -r color=$1; shift;
        echo "$color \$ $* $nocolor"; eval $*;
    }

    # Main --------------------

    declare -r fullpath=`join_by_separator "$@"`
    declare -r filename=`basename $fullpath`
    declare -r dirpath=`dirname $fullpath`

    echo_and_run $blue "mkdir -p $dirpath"
    echo_and_run $blue "cd $dirpath"
    echo_and_run $purple "touch $filename"
    echo_and_run $purple "$opener $filename"
}
