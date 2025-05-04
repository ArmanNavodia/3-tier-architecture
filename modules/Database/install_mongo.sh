#!bin/bash
sudo su << EOF
echo "starting"
apt-get install gnupg curl
echo "gnupg installed"
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
echo "starting update"
apt-get update -y
echo "starting mongodb-org"
apt-get install -y mongodb-org
echo "start mongod service"
systemctl daemon-reload 
systemctl start mongod 
echo "check mongod status"
systemctl status mongod --no-pager
echo "finished"
echo "mongo installed successfully"
exit
exit