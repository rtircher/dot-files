#! /bin/bash

# Look here for more info about git subtrees: https://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/

git remote add -f rupa-z git@github.com:rupa/z.git
git subtree add --prefix files/.zsh/vendor/rupa-z rupa-z master --squash
