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
    published='20'${mdfile:0:2}'-'${mdfile:2:2}'-'${mdfile:4:2}
    # cards
    if [[ "$type" == "card" ]]; then
      local cardholder=$(mktemp cardholder.md)
      # cat >> $3 <<EOF
      cat >> $cardholder <<EOF
<div class="card blog-post">
  <h3>$title</h3>
  <img src="$image"/>
  <p>$summary</p>
  <p>$published</p>
  <a href="$url.html">read</a>
</div>
EOF
      cat $cardholder $3 > temp && mv temp $3
      rm cardholder.md
      target=$url.html
      cat $1 > ${target}
      local qt=$(mktemp tmp.md)
      sed -n '8,$p' ${file}.md > tmp.md
      sed -i '' '/./,$!d' tmp.md
      cmark --unsafe tmp.md >> ${target}
      cat $2 >> ${target}
      sed -i '' -e 's#DATE#'$date'#g' ${target}
      echo "   $folder \\\ $file: built :)"
      rm tmp.md
    else
      target=${file}.html
      cat $1 > ${target}
      cmark --unsafe ${file}.md >> ${target}
      cat $2 >> ${target}
      sed -i '' -e 's#DATE#'$date'#g' ${target}
      echo "$folder \\\ $file built"
    fi
  done
}
md2html "cardhead.htm_" "cardfoot.htm_" "index.md"

echo -e '## liner notes\n' | cat - "index.md" > temp && mv temp "index.md"