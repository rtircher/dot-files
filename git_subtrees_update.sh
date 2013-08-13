#! /bin/bash

git fetch rupa-z master
git subtree pull --prefix files/.zsh/vendor/rupa-z rupa-z master --squash
