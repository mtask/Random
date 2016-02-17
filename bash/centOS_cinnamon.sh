yum -y install epel-release

sed -i -e "s/\]$/\]\npriority=5/g" /etc/yum.repos.d/epel.repo # set [priority=5]
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel.repo # for another way, change to [enabled=0] and use it only when needed
yum --enablerepo=epel install [Package] # if [enabled=0], input a command to use the repository
yum --enablerepo=epel -y install cinnamon*
echo "exec /usr/bin/cinnamon-session" >> ~/.xinitrc
