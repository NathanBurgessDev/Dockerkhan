#Docker - https://docs.docker.com/engine/install/ubuntu/ 
sudo apt-get remove -y docker docker-engine docker.io containerd runc 
sudo apt-get update 
sudo apt-get install -y ca-certificates curl gnupg lsb-release 
sudo mkdir -p /etc/apt/keyrings 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
sudo apt-get update 
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin 
# add user to docker group 
sudo usermod -aG docker $USER 
# check 
#newgrp docker 
echo "log in again and try: docker run hello-world"

# old docker compose, just in case? 
sudo curl -SL https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose 
sudo chmod 0755 /usr/local/bin/docker-compose

# standard utils
sudo apt-get install -y curl
