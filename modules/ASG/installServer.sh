#!/bin/sh
set -e

# Run this script like - bash script-name.sh

# Define versions
INSTALL_NODE_VER=16.20.2
INSTALL_NVM_VER=0.39.0
INSTALL_YARN_VER=1.22.21

# You can pass argument to this script --version 8
if [ "$1" = '--version' ]; then
	echo "==> Using specified node version - $2"
	INSTALL_NODE_VER=$2
fi

echo "==> Ensuring .bashrc exists and is writable"
touch ~/.bashrc

echo "==> Installing node version manager (NVM). Version $INSTALL_NVM_VER"
# Removed if already installed
rm -rf ~/.nvm

# Install nvm 
curl -o- https://raw.githubusercontent.com/creationix/nvm/v$INSTALL_NVM_VER/install.sh | bash

echo "export path"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
 [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
echo "==> Installing node js version $INSTALL_NODE_VER"
nvm install $INSTALL_NODE_VER

echo "==> Make this version system default"
nvm alias default $INSTALL_NODE_VER
nvm use default

# echo -e "==> Update npm to latest version, if this stuck then terminate (CTRL+C) the execution"
# npm install -g npm


echo "==> Checking for versions"
nvm --version
node --version
npm --version

echo "==> List installed node versions"
nvm ls

nvm cache clear
echo "==> Now you're all setup and ready for development. If changes are yet totake effect, I suggest you restart your computer"

# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# source ~/.bashrc
# nvm install --lts
# node -e "console.log('Running Node.js ' + process.version)"


# unzip and make frontent running
sudo apt install unzip
sudo apt install git
cd /home/ubuntu/
git clone https://github.com/Sachin24063/server.git
cd server
unzip server.zip
pwd
cd server
# . /home/ubuntu/.nvm/nvm.sh
# . /home/ubuntu/.profile
# . /home/ubuntu/.bashrc
nvm -v
node -v
npm -v
npm i --force
npm install pm2 -g
pm2 --name server start npm -- start
pm2 ps
# npm start
echo "started development server"
exit