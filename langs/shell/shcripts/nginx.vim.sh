#!/bin/bash

[[ -d ~/.vim/syntax ]] || mkdir  -p ~/.vim/syntax
cd ~/.vim/syntax
wget http://www.vim.org/scripts/download_script.php?src_id=14376 -O ~/.vim/syntax/nginx.vim
echo "au BufRead,BufNewFile /usr/local/nginx/* set ft=nginx" >> ~/.vim/filetype.vim
