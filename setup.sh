#!/bin/bash

ls -1dA `pwd`/files/* `pwd`/files/.* | while read f; do
  [ "$f" == `pwd`/files/. ] ||
  [ "$f" == `pwd`/files/.. ] ||
  [ "$f" == `pwd`/files/.git ] ||
  ln -vsf "$f" ~
done

if [ ! `which brew` ]; then
  echo "--> installing homebrew"
  ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
else
  echo "Homebrew already installed -- skipping"
fi

if [[ $? != 0 ]]; then
  echo "!!!!!!!!!! Brew install failed !!!!!!!!!!"
else
  echo "--> installing brew packages"
  brew install ack node zsh aspell git tree
fi

if [ ! `which rvm` ]; then
  echo "--> installing RVM"
  curl -L get.rvm.io | bash -s stable --ruby

  if [[ $? != 0 ]]; then
    echo "!!!!!!!!!! RVM install failed !!!!!!!!!!"
  fi
else
  echo "RVM already installed -- skipping"
fi

echo "--> installing emacs"
brew install emacs --cocoa --srgb --keep-ctag

EMACS_BIN="/usr/local/bin/`readlink /usr/local/bin/emacs`"
EMACS_HOME="`dirname $EMACS_BIN`/.."
EMACS_APP="$EMACS_HOME/Emacs.app"

echo "  changing emacs icon"
mv $EMACS_APP/Contents/Resources/Emacs.icns $EMACS_APP/Contents/Resources/Emacs.old.icns
cp bin/Emacs.icns $EMACS_APP/Contents/Resources/

echo "  linking emacs app"
ln -svf $EMACS_APP /Applications

echo "  linking emacs for command line access"
sudo mv /usr/bin/emacs /usr/bin/emacs.old
sudo ln -svf /usr/local/bin/emacs /usr/bin/emacs
sudo mv /usr/bin/emacsclient /usr/bin/emacsclient.old
sudo ln -svf /usr/local/bin/emacsclient /usr/bin/emacsclient

echo "Emacs installed successfully"
