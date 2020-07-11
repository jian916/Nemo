#!/bin/bash

dos2unix "$1"
isutf8 "$1" >>out.log
sed -i "s|\t|    |g" "$1"
sed -i 's/[[:blank:]]*$//' "$1"
sed -i 's|[)][[:blank:]]*[{]|)\n{|' "$1"
sed -i 's|else[[:blank:]]*[{]|else\n{|' "$1"
sed -i 's|[}][[:blank:]]*else|}\nelse|' "$1"
