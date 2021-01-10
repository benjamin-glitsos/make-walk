#!/usr/bin/env bash

# TODO: not_empty_path not working

function makewalk {
    # Environment Variables --------------------

    MAKEWALK_SEPARATOR="${MAKEWALK_SEPARATOR:=-}"
    MAKEWALK_DELIMITER="${MAKEWALK_DELIMITER:=,}";
    MAKEWALK_OPENER="${MAKEWALK_OPENER:=xdg-open}";

    # Constants --------------------

    declare -r empty_path=".";

    # Colors --------------------

    declare -r red="\033[0;31m";
    declare -r purple="\033[0;35m";
    declare -r cyan="\033[0;36m";
    declare -r nocolor="\033[0m";

    # Utilities --------------------

    function not_empty_path {
        if [[ $* != $empty_path ]]; then
            return;
        fi
        false
    }

    function does_end_with_slash {
        if [[ $* =~ "/$" ]]; then
            return;
        fi
        false;
    }

    function join_by_separator {
        declare IFS=$MAKEWALK_SEPARATOR; echo "$*";
    }

    function split_by_delimiter {
        IFS="$MAKEWALK_DELIMITER" read -r -a SPLIT_BY_DELIMITER_ARRAY <<< $*;
    }

    function colorise {
        declare -r color=$1; shift;
        echo "$color$*$nocolor"
    }

    function echo_and_run {
        declare -r shell_symbol=`colorise $cyan \$`;
        declare -r shell_command=`colorise $purple $*`;
        echo "$shell_symbol $shell_command";
        eval $*;
    }

    # Main --------------------

    declare -r fullpath=`join_by_separator "$@"`;

    if not_empty_path "$fullpath" && [ ! -z "$fullpath" ]; then
        if does_end_with_slash $fullpath; then
            declare -r filenames=$empty_path;
            declare -r dirpath="$fullpath";
        else
            declare -r filenames=`basename $fullpath`;
            declare -r dirpath=`dirname $fullpath`;
        fi

        if not_empty_path $dirpath; then
            echo_and_run "mkdir -p $dirpath && cd $dirpath";
        fi

        if not_empty_path $filenames; then
            split_by_delimiter $filenames;
            for filename in "${SPLIT_BY_DELIMITER_ARRAY[@]}"
            do
                echo_and_run "touch $filename && $MAKEWALK_OPENER $filename";
            done
        fi
    else
        echo `colorise $red "No path provided."`;
        return 1;
    fi
}
