#!/bin/bash

echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

export PATH="/usr/local/bin:$PATH"

brew tap caskroom/versions
brew cask install java8

brew install ruby

brew install carthage

sudo gem install --force --no-document xcode-install
sudo XCODE_INSTALL_USER="$XCODE_INSTALL_USER" XCODE_INSTALL_PASSWORD="$XCODE_INSTALL_PASSWORD" xcversion install "$XCODE_VERSION"

# Ensure there is only one instance of `/Applications/Xcode*` because `fastlane`
# seems to be confused when the symlink created by `xcversion` is present
sudo rm /Applications/Xcode.app
sudo mv "/Applications/Xcode-$XCODE_VERSION.app" /Applications/Xcode.app
sudo xcode-select --switch /Applications/Xcode.app
