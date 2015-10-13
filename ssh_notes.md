##SSH keys
- Generate rsa-key pair

Basic:
$ ssh-keygen -t rsa

Advanced:

$ ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -C "Comment about your key goes here."

- Set correct permissions

$ chmod 700 ~/.ssh && chmod 600 ~/.ssh/*

- Push the key to the remote server, modifying it to match your server name

$ cat ~/.ssh/id_rsa.pub | ssh user@123.45.56.78 "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"

or

$ ssh-copy-id username@remote_host

or

$ scp ~/.ssh/id_rsa.pub root@example.com:.ssh/authorized_keys &#35;if first key at server

- Get key fingerprint

$ ssh-keygen -l -f <file>

##sshd_config

- Open sshd_config file

$ sudo nano /etc/ssh/sshd_config

- Define if password authentication is on or off

PasswordAuthentication yes/no

- Define if root user can login throug ssh

PermitRootLogin no/yes

- Define which users can login through ssh

AllowUsers user1 user2 user3

- Allow port forwarding

GatewayPorts yes

##Tunneling

- Socks server

$ ssh -D 1234 user@server.com &#35; Socks server runnig 127.0.0.1:1234

- Local port forwarding

$ ssh -L 6060:localhost:23 user@server.com

- Local forward to other machines inside local network

$ ssh server.com -L 123:192.168.6.12:1337 -N

- Reverse tunnel

$ ssh -R 1337:localhost:23 user@server.com