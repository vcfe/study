#!/bin/bash
sudo -i
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin/PermitRootLogin yes/' /etc/ssh/sshd_config
passwd root
systemctl restart ssh
d=$(cd `dirname $0`; pwd)
echo $d$0
