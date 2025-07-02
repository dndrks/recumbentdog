#!/bin/bash

cd ..
echo ">> root .md to .html"

function md2html(){
  # local file folder mdfile target date
  for mdfile in *.md; do
    file=${mdfile%.*}
    date=$(date -r ${file}.md +%y%m%d)
    folder=$(basename $(pwd))
    echo "building $folder /// $file"
    target=${file}.html
    cat $1 > ${target}
    cmark --unsafe ${file}.md >> ${target}
    cat $2 >> ${target}
    sed -i '' -e 's#DATE#'$date'#g' ${target}
    echo "$folder \\\ $file built"
  done
}
md2html "head.htm_" "foot.htm_"