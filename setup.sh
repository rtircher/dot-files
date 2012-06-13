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

echo "#### Installing emacs"
mkdir emacs_install
tar -xvf bin/emacs-24.1.tar.gz -C emacs_install
cd emacs_install/emacs-24.1
./configure --with-ns && make install
if [[ $? != 0 ]]; then
  mv nextstep/Emacs.app/Contents/Resources/Emacs.icns nextstep/Emacs.app/Contents/Resources/Emacs.old.icns
  cp ../../bin/Emacs.icns nextstep/Emacs.app/Contents/Resources/
  cp -r nextstep/Emacs.app /Developer/Applications/
  echo "Emacs installed successfully"
fi
cd ../../
rm -rf emacs_install