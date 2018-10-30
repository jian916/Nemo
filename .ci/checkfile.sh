#!/bin/bash

dos2unix "$1"
isutf8 "$1" || exit 1
