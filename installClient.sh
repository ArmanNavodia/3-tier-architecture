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
sudo apt install unzip
sudo apt install git
# cd /home/ubuntu/
cd /home/ubuntu/
git clone https://github.com/Sachin24063/client.git
cd client/

sudo apt install nginx -y
sudo ufw allow 'Nginx HTTP'
sudo systemctl enable nginx
sudo systemctl start nginx
echo finding dns name
echo 'ALB_DNS_NAME=${alb_dns}'
echo "export SERVER_URL=http://${alb_dns}" >> /home/ubuntu/.bashrc
export SERVER_URL=http://${alb_dns}
echo $SERVER_URL
echo "set finished"
envsubst '$SERVER_URL' < /home/ubuntu/client/nginx_conf.template > /home/ubuntu/client/nginx.conf 
sudo mv /home/ubuntu/client/nginx.conf /etc/nginx/
sudo nginx -t
sudo systemctl reload nginx
echo "started development server"
exit