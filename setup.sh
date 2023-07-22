#!/bin/bash

set -e -u

LINK_FILE_DIR="`pwd`/files"
ls -1dA "$LINK_FILE_DIR/bin" $LINK_FILE_DIR/.* | while read f; do
  [ "$f" == `pwd`/files/. ] ||
  [ "$f" == `pwd`/files/.. ] ||
  [ "$f" == `pwd`/files/.git ] ||
  ln -vsf "$f" ~
done

mkdir -p ~/.ssh/
ln -vsf "$LINK_FILE_DIR/ssh_config" ~/.ssh/config

if [ ! `which brew` ]; then
  echo "--> installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed -- skipping"
fi

# Ensure analytics are off
brew analytics off
# if running on old install and to avoid errors when installing existing brew package, we upgrade first
brew upgrade

echo "--> installing brew packages"
source Brewfile

if  [ ! `which rvm` ]; then
  echo "--> installing RVM"
  curl -sSL https://get.rvm.io | bash -s stable
else
  echo "RVM already installed -- skipping"
fi

# echo "--> installing emacs"
# brew install emacs --cocoa --srgb --keep-ctag

# EMACS_BIN="/usr/local/bin/`readlink /usr/local/bin/emacs`"
# EMACS_HOME="`dirname $EMACS_BIN`/.."
# EMACS_APP="$EMACS_HOME/Emacs.app"

# echo "  changing emacs icon"
# mv $EMACS_APP/Contents/Resources/Emacs.icns $EMACS_APP/Contents/Resources/Emacs.old.icns
# cp bin/Emacs.icns $EMACS_APP/Contents/Resources/

# echo "  copying emacs to /Applications"
# cp -r $EMACS_APP /Applications/Emacs.app

# echo "Emacs installed successfully"

echo "--> Changing shell to zsh"
if [ "$SHELL" == '/bin/zsh' ]; then
  echo "Already using zsh -- shipping"
else
  chsh -s /bin/zsh $USER
fi

# Ensure we still have the homebrew utilities in /usr/local/bin in Apple silicon
if [[ ! -a /usr/local/bin/ ]]; then
  sudo ln -s /opt/homebrew/bin /usr/local/bin
fi

echo "--> installing cask packages"
source Caskfile

echo "--> Installing pyton"
pyenv install -s 3.10.4
pyenv global system 3.10.4

echo "--> Installing aws tools"
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

echo "--> link Visual Studio Code config"
VSC_SUPPORT_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSC_SUPPORT_DIR"
ls -1dA `pwd`/vsc/* | while read f; do
  ln -vsf "$f" "$VSC_SUPPORT_DIR"
done

EXTENSIONS=(
  "arjun.swagger-viewer" \
  "castwide.solargraph" \
  "Dart-Code.dart-code" \
  "Dart-Code.flutter" \
  "dbaeumer.vscode-eslint" \
  "eamodio.gitlens" \
  "esbenp.prettier-vscode" \
  "Flutterbricksproductions.flutterbricks" \
  "gimenete.github-linker" \
  "gmlewis-vscode.flutter-stylizer" \
  "golang.go" \
  "hashicorp.terraform" \
  "karunamurti.haml" \
  "LeetCode.vscode-leetcode" \
  "mechatroner.rainbow-csv" \
  "michelemelluso.code-beautifier" \
  "ms-azuretools.vscode-docker" \
  "ms-python.isort" \
  "ms-python.python" \
  "ms-python.vscode-pylance" \
  "ms-vscode.makefile-tools" \
  "Nash.awesome-flutter-snippets" \
  "octref.vetur" \
  "rebornix.Ruby" \
  "redhat.vscode-yaml" \
  "streetsidesoftware.code-spell-checker" \
  "wingrunr21.vscode-ruby" \
)
echo "  Installing VS Code extensions"
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION --force
done

echo "--> link iTerm2 config"
mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
ln -vsf "`pwd`/iterm2/dynamic-profiles.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles"

echo "--> setup fzf"
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

echo "--> Configuring OSX"
source osx_config.sh
