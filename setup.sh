#!/bin/bash

ls -1dA `pwd`/files/* `pwd`/files/.* | while read f; do
  [ "$f" == `pwd`/files/. ] ||
  [ "$f" == `pwd`/files/.. ] ||
  [ "$f" == `pwd`/files/.git ] ||
  ln -vsf "$f" ~
done

echo "Installing brew"
/usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"

if [[ $? != 0 ]]; then
  echo "!!!!!!!!!! Brew install failed !!!!!!!!!!"
else
  echo "--> Installing brew packages"
  brew install ack emacs leiningen node zsh aspell git tree
fi

echo "--> Installing RVM"
curl -L get.rvm.io | bash -s stable --ruby

if [[ $? != 0 ]]; then
  echo "!!!!!!!!!! RVM install failed !!!!!!!!!!"
fi
