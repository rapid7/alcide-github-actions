#!/usr/bin/env bash

######################
### common functions
######################


function error()
{
    printf "Error: %s\n" "$1"
    exit 1
}

