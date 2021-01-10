#!/bin/bash

function join_by_separator() {
    local IFS="-"; echo "$*";
}

join_by_separator "$@"
