#!/bin/bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
source ~/.bashrc
nvm install 16.20.2
nvm alias default 16.20.2
nvm use default
node -e "console.log('Running Node.js ' + process.version)"
node --version
version=$(node --version)
echo "export PATH=\$PATH:/.nvm/versions/node/$version/bin/" >> ~/.bashrc

sudo apt-get update -y
sudo apt install git
cd /home/ubuntu/
git clone https://github.com/Sachin24063/server.git
cd server
echo "export PATH=\$PATH:/.nvm/versions/node/$version/bin/" >> ~/.bashrc
echo "export MONGODB_URL_CONNECTION=${MONGO_URL}" >> /home/ubuntu/.bashrc
export MONGODB_URL_CONNECTION=${MONGO_URL}
echo "mongodb url: $MONGODB_URL_CONNECTION"
npm install pm2 -g
npm install nodemon@latest --save-dev
npm cache clean --force
rm -rf node_modules
npm install --force

# PM2=/root/server/node_modules/pm2/bin/pm2
# export PM2_HOME="/home/ubuntu/.pm2"
# su - ec2-user -c "PATH=$PATH; PM2_HOME=$PM2_HOME $PM2 start /home/ec2-user/api.json -u ec2-user"
 pm2 --name server start npm -- start
 pm2 ps
# npm start
echo "started development server"
exit