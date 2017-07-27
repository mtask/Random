apt-get update -y && apt-get upgrade -y && apt-get install -y ufw sudo && clear

read -p "New User: " USERNAME
useradd -m -G users,sudo -s /bin/bash $USERNAME  && clear

read -p "SSH port: " SSH_PORT
sed -i -e 's/Port 22/Port '"$SSH_PORT"'/g' /etc/ssh/sshd_config
sed -i -e 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart

ufw default deny incoming
ufw default allow outgoing
ufw allow $SSH_PORT/tcp
