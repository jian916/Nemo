#!/bin/bash

dos2unix "$1"
isutf8 "$1" >>out.log
