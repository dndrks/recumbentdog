echo ">> building site"
zsh ./md2html.sh
cd ..
cd notes
zsh ./cards.sh
echo ">> site built"