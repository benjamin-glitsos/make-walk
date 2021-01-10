#!/usr/bin/env bash

declare -rf makewalk() {
    # Settings --------------------

    # TODO: make these environment variables
    declare -r separator="-";
    declare -r file_delimiter=",";
    declare -r opener="xdg-open";

    # Constants --------------------

    declare -r empty_path=".";

    # Colors --------------------

    declare -r purple="\033[0;35m";
    declare -r cyan="\033[0;36m";
    declare -r nocolor="\033[0m";

    # Utilities --------------------

    declare -rf not_empty_path() {
        if [[ $* != $empty_path ]]; then
            return;
        fi
        false
    }

    declare -rf does_end_with_slash() {
        if [[ $* =~ "/$" ]]; then
            return;
        fi
        false;
    }

    declare -rf join_by_separator() {
        declare IFS=$separator; echo $*;
    }

    declare -rf split_by_delimiter() {
        declare -r delimiter=$1; shift;
        echo $* | tr $delimiter "\n";
    }

    # TODO: create function that surrounds a string in the desired colour

    declare -rf echo_and_run() {
        declare -r shell_symbol="$cyan\$$nocolor";
        declare -r shell_command="$purple$*$nocolor";
        echo "$shell_symbol $shell_command"; eval $*;
    }

    # Main --------------------

    declare -r fullpath=`join_by_separator "$@"`;

    if not_empty_path $fullpaths || [ -z "$fullpaths" ]; then
        if does_end_with_slash $fullpath; then
            declare -r filenames=$empty_path;
            declare -r dirpath=$fullpath;
        else
            declare -r filenames=`basename $fullpath`;
            declare -r dirpath=`dirname $fullpath`;
        fi

        if not_empty_path $dirpath; then
            echo_and_run "mkdir -p $dirpath && cd $dirpath";
        fi

        if not_empty_path $filenames; then
            for filename in `split_by_delimiter $file_delimiter $filenames`
            do
                echo_and_run "touch $filename && $opener $filename";
            done
        fi
    # TODO: echo red error message in an else clause here
    fi
}
