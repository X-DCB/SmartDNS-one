#!/bin/bash
while [[ ! $sqx =~ Y|y|N|n ]]; do
	read -p "Shareable RP? [Y/y] [N/n] " sqx;done
export sqx=$sqx
read -p "Location: [SG] " vloc
vloc=${vloc:-SG}
[ $vloc = SG ] && vlocx=squidx-serv
if [[ ! `type -P docker` ]]; then
if [ -f /etc/debian* ]; then
apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt-cache policy docker-ce
apt install docker-ce -y
apt clean
else
yum install -y yum-utils device-mapper-persistent-data lvm2 wget curl
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --with-fingerprint --import
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y; fi; fi
[ `type -P dcomp` ] || wget "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -qO /sbin/dcomp
chmod +x /sbin/dcomp || return
IP=$(wget -qO- ipv4.icanhazip.com)
DNUL="/dev/null"
CONFDIR="/etc/_configs"
GITMINE="https://raw.githubusercontent.com/X-DCB/SmartDNS-one/master"
docker service ls 2> $DNUL || docker swarm init --advertise-addr $IP
docker stack rm dnsx 2> $DNUL
spin='-\|/'
str='Removing possible errors...'
cnl='Cancelled.'
fin='Finished.'
trap 'printf "\b\b$cnl%$(( ${#str}-${#cnl}+1 ))s\n";exit' INT
while [[ `docker network ls | grep dnsx` ]]; do
i=$(( (i+1) %4 ))
printf "\b${str}${spin:$i:1} \r"
sleep .1
done
printf "\b\b$fin%$(( ${#str}-${#fin}+1 ))s\n"
mkdir $CONFDIR 2> $DNUL
wget $GITMINE/sniproxy.conf -qO $CONFDIR/sniproxy.conf 
wget $GITMINE/dnsmasq.conf -qO $CONFDIR/dnsmasq.conf
wget $GITMINE/squid.conf -qO $CONFDIR/squid.conf
wget $GITMINE/sni-dns.conf -qO $CONFDIR/sni-dns.conf
wget $GITMINE/daemon.json -qO /etc/docker/daemon.json
service squid stop 2> $DNUL
wget $GITMINE/docker.yaml -qO- | dcomp -f - down 2> $DNUL
wget $GITMINE/docker.yaml -qO- | dcomp -f - up -d $vlocx
# iptables
echo "[Unit]
Description=OpenVPN IP Table
Wants=network.target
After=network.target
DefaultDependencies=no
[Service]
ExecStart=/sbin/nfiptab
Type=oneshot
RemainAfterExit=yes
[Install]
WantedBy=network.target" > /etc/systemd/system/nfiptab.service
echo -e '#!/bin/bash
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -A INPUT -j ACCEPT
iptables -A FORWARD -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited' > /sbin/nfiptab
chmod +x /sbin/nfiptab && nfiptab
systemctl daemon-reload
systemctl enable nfiptab && systemctl restart nfiptab docker
echo -ne "\nInstall finished.\nPlease reboot your vps.\n"