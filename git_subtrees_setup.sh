#! /bin/bash

git remote add -f rupa-z git@github.com:rupa/z.git
git subtree add --prefix files/.zsh/vendor/rupa-z rupa-z master --squash
