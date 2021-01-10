# MakeWalk

A single command that combines `mkdir -p`, `touch`, `cd`, `xdg-open`, `ls` and joins filenames with a separator. It is designed to be very fast and also highly configurable.

## Requirements

Supported operating systems:

* Linux

Supported shells:

* Bash
* Zsh

## Installation

This program is a single bash script which you can download, put into your PATH and then alias in your `.bashrc`:

```console
$ git clone git@github.com:benjamin-glitsos/makewalk.git
$ cd makewalk/
$ mv makewalk.sh ~/bin/makewalk.sh
$ cd ..
$ rm -r makewalk/
```

Then in your `.bashrc`:

```bash
source makewalk.sh;
alias m="makewalk";
```

## Usage

```console
$ m new folder/second folder/new file.txt,.dotfile example,third file.txt

# Output:
# $ mkdir -p new-folder/second-folder && cd new-folder/second-folder
# $ touch new-file.txt && xdg-open new-file.txt
# $ touch .dotfile-example && xdg-open .dotfile-example
# $ touch third-file.txt && xdg-open third-file.txt
```

## Configuration

Most parts of this application are configurable, and there are even some additional features that you can enable. Configuration is done through the use of environment variables which you can set in your `.profile`.

Here are all of the environment variables that you can configure, except these examples are set to their default values for your reference:

```bash
export MAKEWALK_PATH_JOINER="-"
export MAKEWALK_FILE_DELIMITER=",";

export MAKEWALK_DIRECTORY_MAKE_COMMAND="mkdir -p";
export MAKEWALK_DIRECTORY_ENTER_COMMAND="cd";
export MAKEWALK_DIRECTORY_PRINT_COMMAND="ls";
export MAKEWALK_FILE_MAKE_COMMAND="touch";
export MAKEWALK_FILE_OPEN_COMMAND="xdg-open";

export MAKEWALK_DISABLE_DIRECTORY_JOINING="no";
export MAKEWALK_DISABLE_FILE_DELIMITING="no";

export MAKEWALK_DISABLE_CONSOLE_PRINT="yes";
export MAKEWALK_DISABLE_CONSOLE_COLORS="yes";
export MAKEWALK_DISABLE_DIRECTORY_MAKE="no";
export MAKEWALK_DISABLE_DIRECTORY_ENTER="no";
export MAKEWALK_ENABLE_DIRECTORY_PRINT="no";
export MAKEWALK_DISABLE_FILE_OPEN="no";

export MAKEWALK_COLOR_BODY="0;35";
export MAKEWALK_COLOR_HIGHLIGHT="0;36";
export MAKEWALK_COLOR_ERROR="0;31";
```
