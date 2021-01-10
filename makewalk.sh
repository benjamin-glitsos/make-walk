#!/usr/bin/env bash

declare -rf makewalk() {
    # Settings --------------------

    declare -r separator="-"
    declare -r opener="xdg-open"

    # Constants --------------------

    declare -r empty_path="."
    declare -r purple="\033[0;35m"
    declare -r nocolor="\033[0m"

    # Utilities --------------------

    declare -rf join_by_separator() {
        declare IFS=$separator; echo $*;
    }

    declare -rf not_empty_path() {
        if [[ $* != $empty_path ]]; then
            return
        fi
        false
    }

    declare -rf does_end_with_slash() {
        if [[ $* =~ "/$" ]]; then
            return
        fi
        false
    }

    declare -rf echo_and_run() {
        echo "\$$purple $* $nocolor"; eval $*;
    }

    # Main --------------------

    declare -r fullpath=`join_by_separator "$@"`

    if does_end_with_slash $fullpath; then
        declare -r filename=$empty_path
        declare -r dirpath=$fullpath
    else
        declare -r filename=`basename $fullpath`
        declare -r dirpath=`dirname $fullpath`
    fi

    # TODO: split filenames by comma then use a for loop to echo_and_run a touch and opener command for each
    if not_empty_path $dirpath; then
        echo_and_run "mkdir -p $dirpath && cd $dirpath"
    fi

    if not_empty_path $filename; then
        echo_and_run "touch $filename && $opener $filename"
    fi
}
