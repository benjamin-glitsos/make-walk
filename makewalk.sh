#!/usr/bin/env bash

function makewalk {
    # Environment Variables --------------------

    MAKEWALK_PATH_JOINER="${MAKEWALK_PATH_JOINER:=-}"
    MAKEWALK_FILE_DELIMITER="${MAKEWALK_FILE_DELIMITER:=,}";

    MAKEWALK_DIRECTORY_MAKE_COMMAND="${MAKEWALK_DIRECTORY_MAKE_COMMAND:=mkdir -p}";
    MAKEWALK_DIRECTORY_ENTER_COMMAND="${MAKEWALK_DIRECTORY_ENTER_COMMAND:=cd}";
    MAKEWALK_DIRECTORY_PRINT_COMMAND="${MAKEWALK_DIRECTORY_PRINT_COMMAND:=ls}";
    MAKEWALK_FILE_MAKE_COMMAND="${MAKEWALK_FILE_MAKE_COMMAND:=touch}";
    MAKEWALK_FILE_OPEN_COMMAND="${MAKEWALK_FILE_OPEN_COMMAND:=xdg-open}";

    MAKEWALK_DISABLE_PATH_JOINING="${MAKEWALK_DISABLE_PATH_JOINING:=no}";
    MAKEWALK_DISABLE_FILE_DELIMITING="${MAKEWALK_DISABLE_FILE_DELIMITING:=no}";

    MAKEWALK_DISABLE_CONSOLE_PRINT="${MAKEWALK_DISABLE_CONSOLE_PRINT:=no}";
    MAKEWALK_DISABLE_CONSOLE_COLORS="${MAKEWALK_DISABLE_CONSOLE_COLORS:=no}";
    MAKEWALK_DISABLE_DIRECTORY_MAKE="${MAKEWALK_DISABLE_DIRECTORY_MAKE:=no}";
    MAKEWALK_DISABLE_DIRECTORY_ENTER="${MAKEWALK_DISABLE_DIRECTORY_ENTER:=no}";
    MAKEWALK_ENABLE_DIRECTORY_PRINT="${MAKEWALK_ENABLE_DIRECTORY_PRINT:=no}";
    MAKEWALK_DISABLE_FILE_OPEN="${MAKEWALK_DISABLE_FILE_OPEN:=no}";

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
        if [ -n "$ZSH_VERSION" ]; then
           read -rA SPLIT_BY_FILE_DELIMITER_ARRAY <<< $*;
        else
           read -ra SPLIT_BY_FILE_DELIMITER_ARRAY <<< $*;
        fi
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
                declare -r make_path="$MAKEWALK_DIRECTORY_MAKE_COMMAND $dirpath"
                declare -r enter_path="$MAKEWALK_DIRECTORY_ENTER_COMMAND $dirpath"

                if is_yes $MAKEWALK_DISABLE_DIRECTORY_MAKE; then
                    echo_and_run "$enter_path";
                else
                    echo_and_run "$make_path && $enter_path";
                fi
            fi

            if not_empty_path $filenames; then
                function filename_run {
                    declare -r filename=$*;
                    declare -r make_file="$MAKEWALK_FILE_MAKE_COMMAND $filename";
                    declare -r open_file="$MAKEWALK_FILE_OPEN_COMMAND $filename";

                    if is_yes $MAKEWALK_DISABLE_FILE_OPEN; then
                        echo_and_run "$make_file";
                    else
                        echo_and_run "$make_file && $open_file";
                    fi
                }

                if is_yes $MAKEWALK_DISABLE_FILE_DELIMITING; then
                    declare -r filename=$filenames;
                    filename_run $filename;
                else
                    split_by_delimiter $filenames;
                    for filename in "${SPLIT_BY_FILE_DELIMITER_ARRAY[@]}"
                    do
                        filename_run $filename;
                    done
                fi
            fi

            if is_yes $MAKEWALK_DISABLE_DIRECTORY_ENTER || is_yes $MAKEWALK_DISABLE_PATH_JOINING; then
                echo_and_run "$MAKEWALK_DIRECTORY_ENTER_COMMAND $startpath";
            elif is_yes $MAKEWALK_ENABLE_DIRECTORY_PRINT; then
                echo_and_run "$MAKEWALK_DIRECTORY_PRINT_COMMAND";
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
