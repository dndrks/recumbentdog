#!/bin/bash

# clear episode cards:
# > index.md
truncate -s 0 index.md
echo ">> building cards"

function md2html(){
  # local file folder mdfile target date
  for mdfile in *.md; do
    file=${mdfile%.*}
    date=$(date -r ${file}.md +%y%m%d)
    folder=$(basename $(pwd))
    echo "building $folder /// $file"
    
    # parse YAML header:
    local yaml
    yaml=$(awk '/^---$/ {f=!f; next} f' "$mdfile")
    local type title url image summary published
    type=$(echo "$yaml" | grep '^type:' | cut -d: -f2- | xargs)
    title=$(echo "$yaml" | grep '^title:' | cut -d: -f2- | xargs)
    url=$(echo "$yaml" | grep '^url:' | cut -d: -f2- | xargs)
    image=$(echo "$yaml" | grep '^image:' | cut -d: -f2- | xargs)
    summary=$(echo "$yaml" | grep '^summary:' | cut -d: -f2- | xargs)
    published='20'${mdfile:0:2}'.'${mdfile:2:2}'.'${mdfile:4:2}
    # cards
    if [[ "$type" == "card" ]]; then
      local cardholder=$(mktemp cardholder.md)
      cat >> $cardholder <<EOF
<div class="card blog-post">
  <div class="card pubdate">
    <p>$published</p>
  </div>
  <h3><a href="$url.html">$title</a></h3>
  <img src="$image"/>
  <p>$summary</p>
</div>
EOF
      local indexfile="index.md"
      cat $cardholder $indexfile > temp && mv temp $indexfile
      rm cardholder.md
      target=$url.html
      local prefix="../subhead.htm_"
      local suffix="../subfoot.htm_"
      cat "$prefix" > ${target}
      local qt=$(mktemp tmp.md)
      sed -n '8,$p' ${file}.md > tmp.md
      sed -i '' '/./,$!d' tmp.md
      cmark --unsafe tmp.md >> ${target}
      cat "$suffix" >> ${target}
      sed -i '' -e 's#DATE#'$date'#g' ${target}
      echo "   $folder \\\ $file: built :)"
      rm tmp.md
    else
      if [[ $file == "index" ]]; then
        local indexfile="index.md"
        local prefix="cardhead.htm_"
        local suffix="cardfoot.htm_"
        target=${file}.html
        cat $prefix > ${target}
        cmark --unsafe ${file}.md >> ${target}
        cat $suffix >> ${target}
        sed -i '' -e 's#DATE#'$date'#g' ${target}
        echo -e '## liner notes\n' | cat - $indexfile > temp && mv temp $indexfile
        echo "$folder \\\ $file built"
      else
        echo "$file is not index.md, not built"
      fi
    fi
  done
}
md2html