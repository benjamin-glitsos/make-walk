#!/usr/bin/env bash

function makewalk {
    # Environment Variables --------------------

    MAKEWALK_PATH_JOINER="${MAKEWALK_PATH_JOINER:=-}"
    MAKEWALK_FILE_DELIMITER="${MAKEWALK_FILE_DELIMITER:=,}";
    MAKEWALK_FILE_OPENER="${MAKEWALK_FILE_OPENER:=xdg-open}";
    MAKEWALK_DISABLE_PATH_JOINING="${MAKEWALK_DISABLE_PATH_JOINING:=no}";
    MAKEWALK_DISABLE_FILE_DELIMITING="${MAKEWALK_DISABLE_PATH_JOINING:=no}";
    MAKEWALK_DISABLE_PATH_CD="${MAKEWALK_DISABLE_PATH_CD:=no}";
    MAKEWALK_DISABLE_FILE_OPEN="${MAKEWALK_DISABLE_FILE_OPEN:=no}";
    MAKEWALK_DISABLE_CONSOLE_PRINT="${MAKEWALK_DISABLE_CONSOLE_PRINT:=no}";
    MAKEWALK_DISABLE_CONSOLE_COLORS="${MAKEWALK_DISABLE_CONSOLE_COLORS:=no}";
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
        declare IFS=$MAKEWALK_PATH_JOINER;
        echo "$*";
    }

    function split_by_delimiter {
        declare IFS="$MAKEWALK_FILE_DELIMITER";
        read -ra SPLIT_BY_FILE_DELIMITER_ARRAY <<< $*;
    }

    function create_color {
        echo "\033[$*m"
    }

    function colorise {
        declare -r color=$1; shift;
        if is_yes $MAKEWALK_DISABLE_CONSOLE_COLORS; then
            echo "$*";
        else
            echo "$color$*$nocolor";
        fi
    }

    function echo_and_run {
        declare -r shell_symbol=`colorise $highlight_color \$`;
        declare -r shell_command=`colorise $body_color $*`;
        if not_yes $MAKEWALK_DISABLE_CONSOLE_PRINT; then
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

    declare -r startpath=`pwd`

    function main_run {
        if not_empty_path "$full_path" && [[ ! -z "$full_path" ]]; then
            if does_end_with_slash $full_path; then
                declare -r filenames=$empty_path;
                declare -r dirpath="$full_path";
            else
                declare -r filenames=`basename $full_path`;
                declare -r dirpath=`dirname $full_path`;
            fi

            if not_empty_path $dirpath; then
                echo_and_run "mkdir -p $dirpath && cd $dirpath";
            fi

            if not_empty_path $filenames; then
                split_by_delimiter $filenames;
                for filename in "${SPLIT_BY_FILE_DELIMITER_ARRAY[@]}"
                do
                    declare -r touchFilename="touch $filename";
                    declare -r openFilename="$MAKEWALK_FILE_OPENER $filename";

                    if is_yes $MAKEWALK_DISABLE_FILE_OPEN; then
                        echo_and_run "$touchFilename";
                    else
                        echo_and_run "$touchFilename && $openFilename";
                    fi
                done
            fi

            if is_yes $MAKEWALK_DISABLE_PATH_CD; then
                echo_and_run "cd $startpath"
            fi
        else
            echo `colorise $error_color "No path provided."`;
            return 1;
        fi
    }

    if is_yes $MAKEWALK_DISABLE_PATH_JOINING; then
        for full_path in "$@"
        do
            main_run $full_path;
        done
    else
        declare -r full_path=`join_by_separator "$@"`;
        main_run $full_path;
    fi
}
