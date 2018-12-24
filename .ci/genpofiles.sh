#!/bin/bash

rm -rf Nemo.po || true

cd ..
ls ./Patches/*.qs|awk '{print $1"\n"$2}'>./.ci/files.txt
ls ./Core/*.qs|awk '{print $1"\n"$2}'>>./.ci/files.txt

xgettext --default-domain=./.ci/nemo \
  --keyword=_ --keyword=N_ \
  --copyright-holder="Andrei Karas (4144)" \
  --from-code=utf-8 \
  --language=JavaScript \
  --files-from=./.ci/files.txt \
  --directory=. \
  --debug
