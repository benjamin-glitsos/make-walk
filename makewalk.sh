#!/usr/bin/env bash

function makewalk {
    # Environment Variables --------------------

    MAKEWALK_SEPARATOR="${MAKEWALK_SEPARATOR:=-}"
    MAKEWALK_DELIMITER="${MAKEWALK_DELIMITER:=,}";
    MAKEWALK_OPENER="${MAKEWALK_OPENER:=xdg-open}";
    MAKEWALK_DISABLE_CD="${MAKEWALK_DISABLE_CD:=no}";
    MAKEWALK_DISABLE_OPEN="${MAKEWALK_DISABLE_OPEN:=no}";
    MAKEWALK_DISABLE_PRINT="${MAKEWALK_DISABLE_PRINT:=no}";
    MAKEWALK_DISABLE_COLORS="${MAKEWALK_DISABLE_COLORS:=no}";
    MAKEWALK_COLOR_BODY="${MAKEWALK_COLOR_BODY:=0;35}";
    MAKEWALK_COLOR_HIGHLIGHT="${MAKEWALK_COLOR_HIGHLIGHT:=0;36}";
    MAKEWALK_COLOR_ERROR="${MAKEWALK_COLOR_ERROR:=0;31}";

    # Constants --------------------

    declare -r empty_path=".";

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

    function is_yes {
        if [[ $* == "yes" ]]; then
            return;
        fi
        false;
    }

    function not_yes {
        if [[ $* != "yes" ]]; then
            return;
        fi
        false;
    }

    function join_by_separator {
        declare IFS=$MAKEWALK_SEPARATOR;
        echo "$*";
    }

    function split_by_delimiter {
        declare IFS="$MAKEWALK_DELIMITER";
        read -ra SPLIT_BY_DELIMITER_ARRAY <<< $*;
    }

    function create_color {
        echo "\033[$*m"
    }

    function colorise {
        declare -r color=$1; shift;
        if is_yes $MAKEWALK_DISABLE_COLORS; then
            echo "$*";
        else
            echo "$color$*$nocolor";
        fi
    }

    function echo_and_run {
        declare -r shell_symbol=`colorise $highlight_color \$`;
        declare -r shell_command=`colorise $body_color $*`;
        if not_yes $MAKEWALK_DISABLE_PRINT; then
            echo "$shell_symbol $shell_command";
        fi
        eval $*;
    }

    # Colors --------------------

    declare -r body_color=`create_color $MAKEWALK_COLOR_BODY`;
    declare -r highlight_color=`create_color $MAKEWALK_COLOR_HIGHLIGHT`;
    declare -r error_color=`create_color $MAKEWALK_COLOR_ERROR`;
    declare -r nocolor=`create_color 0`;

    # Main --------------------

    declare -r fullpath=`join_by_separator "$@"`;
    declare -r startpath=`pwd`

    if not_empty_path "$fullpath" && [[ ! -z "$fullpath" ]]; then
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
                declare -r touchFilename="touch $filename";
                declare -r openFilename="$MAKEWALK_OPENER $filename";

                if is_yes $MAKEWALK_DISABLE_OPEN; then
                    echo_and_run "$touchFilename";
                else
                    echo_and_run "$touchFilename && $openFilename";
                fi
            done
        fi

        if is_yes $MAKEWALK_DISABLE_CD; then
            echo_and_run "cd $startpath"
        fi
    else
        echo `colorise $error_color "No path provided."`;
        return 1;
    fi
}
