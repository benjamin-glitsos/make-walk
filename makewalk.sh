#!/usr/bin/env bash

declare -rf makewalk() {
    # Settings --------------------

    declare -r separator="-"
    declare -r opener="xdg-open"

    # Colors --------------------

    declare -r blue="\033[0;34m"
    declare -r purple="\033[0;35m"
    declare -r nocolor="\033[0m"

    # Utilities --------------------

    declare -rf join_by_separator() {
        declare IFS=$separator; echo "$*";
    }

    declare -rf not_empty_path() {
        if [[ "$*" != "." ]]; then
            return
        fi
        false
    }

    declare -rf echo_and_run() {
        declare -r color=$1; shift;
        echo "\$$color $* $nocolor"; eval $*;
    }

    # Main --------------------

    declare -r fullpath=`join_by_separator "$@"`
    declare -r filename=`basename $fullpath`
    declare -r dirpath=`dirname $fullpath`

    # TODO: remove these
    echo $filename
    echo $dirpath

    # TODO: check if path ends in slash and if so, append the filename to the dirpath and replace filename with "."
    # TODO: split filenames by comma then use a for loop to echo_and_run a touch and opener command for each
    if not_empty_path $dirpath; then
        echo_and_run $blue "mkdir -p $dirpath"
        echo_and_run $blue "cd $dirpath"
    fi

    if not_empty_path $filename; then
        echo_and_run $purple "touch $filename"
        echo_and_run $purple "$opener $filename"
    fi
}
