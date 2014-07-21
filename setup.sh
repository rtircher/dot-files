#!/bin/bash

RET_CODE=0

ls -1dA `pwd`/files/* `pwd`/files/.* | while read f; do
  [ "$f" == `pwd`/files/. ] ||
  [ "$f" == `pwd`/files/.. ] ||
  [ "$f" == `pwd`/files/.git ] ||
  ln -vsf "$f" ~
done

if [ $RET_CODE == 0 ] && [ ! `which brew` ]; then
  echo "--> installing homebrew"
  ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
  RET_CODE=$?
else
  echo "Homebrew already installed -- skipping"
fi

if [ $RET_CODE == 0 ]; then
  echo "--> installing brew packages"
  brew bundle Brewfile
else
  echo "!!!!!!!!!! Brew install failed !!!!!!!!!!"
fi

if  [ $RET_CODE == 0 ] && [ ! `which rvm` ]; then
  echo "--> installing RVM"
  curl -L get.rvm.io | bash -s stable --ruby
  RET_CODE=$?

  if [ $RET_CODE != 0 ]; then
    echo "!!!!!!!!!! RVM install failed !!!!!!!!!!"
  fi
else
  echo "RVM already installed -- skipping"
fi

if  [ $RET_CODE == 0 ]; then
  echo "--> installing emacs"
  brew install emacs --cocoa --srgb --keep-ctag

  EMACS_BIN="/usr/local/bin/`readlink /usr/local/bin/emacs`"
  EMACS_HOME="`dirname $EMACS_BIN`/.."
  EMACS_APP="$EMACS_HOME/Emacs.app"

  echo "  changing emacs icon"
  mv $EMACS_APP/Contents/Resources/Emacs.icns $EMACS_APP/Contents/Resources/Emacs.old.icns
  cp bin/Emacs.icns $EMACS_APP/Contents/Resources/

  echo "  copying emacs to /Applications"
  cp -r $EMACS_APP /Applications/Emacs.app

  echo "  linking emacs for command line access"
  sudo mv /usr/bin/emacs /usr/bin/emacs.old
  sudo ln -svf /usr/local/bin/emacs /usr/bin/emacs
  sudo mv /usr/bin/emacsclient /usr/bin/emacsclient.old
  sudo ln -svf /usr/local/bin/emacsclient /usr/bin/emacsclient

  echo "Emacs installed successfully"
fi

if [ $RET_CODE == 0 ]; then
  echo "--> installing Slate window mager"
  pushd /Applications &> /dev/null
  curl http://www.ninjamonkeysoftware.com/slate/versions/slate-latest.tar.gz | tar -xz
  open Slate.app
  popd &> /dev/null
fi

if [ $RET_CODE == 0 ]; then
  echo "Changing shel to zsh"
  chsh -s /bin/zsh $USER
fi

if [ $RET_CODE == 0 ]; then
  echo "--> installing cask packages"
  brew bundle Caskfile
fi

echo "don't forget to run the following command to configure MacOS X"
echo "source osx_config.sh"
