#! /bin/bash

# Look here for more info about git subtrees: https://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/

git fetch rupa-z master
git subtree pull --prefix files/.zsh/vendor/rupa-z rupa-z master --squash
