#!/usr/bin/env bash

function makewalk() {
    # Settings --------------------

    readonly separator="-"

    # Utilities --------------------

    function join_by_separator() {
        local IFS=$separator; echo "$*";
    }
    readonly -f join_by_separator &>/dev/null

    function run_and_echo() {
        echo "$*" ; "$@" ;
    }
    readonly -f run_and_echo &>/dev/null

    # Main --------------------

    readonly fullpath=`join_by_separator "$@"`
    readonly filename=`basename $fullpath`
    readonly dirpath=`dirname $fullpath`

    run_and_echo `mkdir -p $dirpath`
    run_and_echo `cd $dirpath`
}
readonly -f makewalk &>/dev/null
