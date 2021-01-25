# MakeWalk

A single command that combines `mkdir -p`, `touch`, `cd`, `xdg-open`, `ls` and joins filenames with a separator. It is designed to be very fast and also highly configurable.

## Requirements

Supported operating systems:

* Linux

Supported shells:

* Bash
* Zsh

Required packages:

* `coreutils`

## Installation

This program is a single bash script and hence it is quite simple to install.

First run commands such as these to download the script and add it to your PATH:

```bash
git clone git@github.com:benjamin-glitsos/makewalk.git
cd makewalk/
mv makewalk.sh ~/bin/makewalk.sh
cd ..
rm -r makewalk/
```

Then in your `.bashrc` you will source and alias the script:

```bash
source makewalk.sh;
alias m="makewalk";
```

## Usage

You can simply make a file:

```
m new file.txt
```

Or make a folder:

```
m new folder/
```

Or make a path of folders containing multiple files like so:

```bash
m new folder/second folder/new file.txt,.dotfile example,another file.txt
```

In this case the console output will be:

```
$ mkdir -p new-folder/second-folder && cd new-folder/second-folder
$ touch new-file.txt && xdg-open new-file.txt
$ touch .dotfile-example && xdg-open .dotfile-example
$ touch another-file.txt && xdg-open another-file.txt
```

And the following files and folders will be created:

```
new-folder
└── second-folder
   ├── .dotfile-example
   ├── another-file.txt
   └── new-file.txt
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

export MAKEWALK_DISABLE_PATH_JOINING="no"; # Note: when this is 'yes', it allows
# you to create multiple directory paths in one command.
# e.g. m a/b/c.txt d/e/f.txt
export MAKEWALK_DISABLE_FILE_DELIMITING="no";
export MAKEWALK_DISABLE_CONSOLE_PRINT="yes";
export MAKEWALK_DISABLE_CONSOLE_COLORS="yes";
export MAKEWALK_DISABLE_DIRECTORY_ENTER="no";
export MAKEWALK_ENABLE_DIRECTORY_PRINT="no";
export MAKEWALK_DISABLE_FILE_OPEN="no";
export MAKEWALK_ENABLE_PWD_PRINT="no";

export MAKEWALK_COLOR_BODY="0;35";
export MAKEWALK_COLOR_HIGHLIGHT="0;36";
export MAKEWALK_COLOR_ERROR="0;31";
export MAKEWALK_COLOR_PWD_PRINT="0;34";
```

I personally use the following configuration:

```bash
export MAKEWALK_DIRECTORY_ENTER_COMMAND="pushd > /dev/null";
export MAKEWALK_FILE_OPEN_COMMAND="vimer";
export MAKEWALK_ENABLE_PWD="yes";
export MAKEWALK_ENABLE_PATHS_PRINT="yes";
```
