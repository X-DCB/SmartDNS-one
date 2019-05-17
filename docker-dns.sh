#!/bin/bash
while [[ ! $sqx =~ Y|y|N|n ]]; do
	read -p "Shareable RP: [Y/y] [N/n] " sqx;done
if [[ ! `which docker` ]]; then
apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt-cache policy docker-ce
apt install docker-ce -y; fi
[ -d /etc/_configs ] || mkdir /etc/_configs
IP=$(wget -qO- ipv4.icanhazip.com)
DNUL="/dev/null"
CONFDIR="/etc/_configs"
GITMINE="https://raw.githubusercontent.com/X-DCB/SmartDNS-one/master"
docker service ls 2> $DNUL || docker swarm init --advertise-addr $IP
docker service rm dnsx 2> $DNUL
wget \
https://raw.githubusercontent.com/X-DCB/netflix-proxy/master/docker-sniproxy/sniproxy.conf.template \
-qO $CONFDIR/sniproxy.conf
wget $GITMINE/sni-dns.conf -qO $CONFDIR/sni-dns.conf
wget $GITMINE/dnsmasq.conf -qO $CONFDIR/dnsmasq.conf
wget $GITMINE/squid.conf -qO $CONFDIR/squid.conf
wget $GITMINE/docker.yaml -qO- | docker stack up -c - dnsx
docker service update $(docker service ls | grep squid | cut -d ' ' -f 1) --args $sqx
