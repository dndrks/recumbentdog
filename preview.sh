#!/bin/bash
echo ">> building preview..."
cd scripts
zsh ./build.sh
cd ..
python3 -m http.server
echo ">> preview built"