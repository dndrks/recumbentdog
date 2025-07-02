echo ">> building site"
zsh ./md2html.sh
cd ..
cd liner-notes
zsh ./cards.sh
echo ">> site built"