cd ..
echo ">> root .md to .html"

list=$(ls -r ./*.md)
for file in $list ; do
  date=$(date -r ${file} +%D)
  file=${file:2}
  file=${file%.*}
  echo "$file"
  # bkg="#FED1C7"
  # font="#333"
  # link="#333"
  # hover="#555"
  # fontsize=0.8em
  target=${file}.html
  cat head.htm_ > ${target}
  cmark --unsafe ${file}.md >> ${target}
  cat foot.htm_ >> ${target}
  # sed -i '' 's|BKG_COLOR|'$bkg'|g' ${target}
  # sed -i '' 's|FONT_COLOR|'$font'|g' ${target}
  # sed -i '' 's|LINK_COLOR|'$link'|g' ${target}
  # sed -i '' 's|HOVER_COLOR|'$hover'|g' ${target}
  # sed -i '' 's|FONT_SIZE|'$fontsize'|g' ${target}
  sed -i '' -e 's#DATE#'$date'#g' ${target}
done