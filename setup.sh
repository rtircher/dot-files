#!/bin/bash

set -e

ls -1dA `pwd`/files/* `pwd`/files/.* | while read f; do
  [ "$f" == `pwd`/files/. ] ||
  [ "$f" == `pwd`/files/.. ] ||
  [ "$f" == `pwd`/files/.git ] ||
  ln -vsf "$f" ~
done

if [ ! `which brew` ]; then
  echo "--> installing homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew already installed -- skipping"
fi

echo "--> installing brew packages"
source Brewfile

if  [ ! `which rvm` ]; then
  echo "--> installing RVM"
  curl -L get.rvm.io | bash -s stable --ruby
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

echo "  copying emacs to /Applications"
cp -r $EMACS_APP /Applications/Emacs.app

echo "  linking emacs for command line access"
sudo mv /usr/bin/emacs /usr/bin/emacs.old
sudo ln -svf /usr/local/bin/emacs /usr/bin/emacs
sudo mv /usr/bin/emacsclient /usr/bin/emacsclient.old
sudo ln -svf /usr/local/bin/emacsclient /usr/bin/emacsclient

echo "Emacs installed successfully"

echo "--> Changing shel to zsh"
chsh -s /bin/zsh $USER

echo "--> installing cask packages"
source Caskfile

echo "--> link Visual Studio Code config"
ls -1dA `pwd`/vsc/* | while read f; do
  ln -vsf "$f" "$HOME/Library/Application Support/Code/User"
done

EXTENSIONS=(
  "HookyQR.beautify" \
  "dbaeumer.vscode-eslint" \
  "eamodio.gitlens" \
  "esbenp.prettier-vscode" \
  "karunamurti.haml" \
  "lukehoban.Go" \
  "michelemelluso.code-beautifier" \
  "octref.vetur" \
  "rebornix.Ruby" \
  "taichi.react-beautify"
)
echo "  Installing VS Code extensions"
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done

echo "--> link iTerm2 config"
ln -vsf "`pwd`/iterm2/dynamic-profiles.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles"

echo "--> Configuring OSX"
source osx_config.sh
