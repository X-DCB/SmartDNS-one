#!/bin/bash
echo 'bind-dynamic
bogus-priv
domain-needed
log-facility=-
local-ttl=60
conf-dir=/etc/dnsmasq.d/,*.conf' > /etc/_configs/dnsmasq.conf
echo 'address=/akadns.net/IPADD
address=/akam.net/IPADD
address=/akamai.com/IPADD
address=/akamai.net/IPADD
address=/akamaiedge.net/IPADD
address=/akamaihd.net/IPADD
address=/akamaistream.net/IPADD
address=/akamaitech.net/IPADD
address=/akamaitechnologies.com/IPADD
address=/akamaitechnologies.fr/IPADD
address=/akamaized.net/IPADD
address=/edgekey.net/IPADD
address=/edgesuite.net/IPADD
address=/srip.net/IPADD
address=/footprint.net/IPADD
address=/level3.net/IPADD
address=/llnwd.net/IPADD
address=/edgecastcdn.net/IPADD
address=/cloudfront.net/IPADD
address=/netflix.com/IPADD
address=/netflix.net/IPADD
address=/nflximg.net/IPADD
address=/nflxvideo.net/IPADD
address=/nflxso.net/IPADD
address=/nflxext.com/IPADD
address=/hulu.com/IPADD
address=/huluim.com/IPADD
address=/hbonow.com/IPADD
address=/hbogo.com/IPADD
address=/hbo.com/IPADD
address=/amazon.com/IPADD
address=/amazon.co.uk/IPADD
address=/amazonvideo.com/IPADD
address=/crackle.com/IPADD
address=/pandora.com/IPADD
address=/vudu.com/IPADD
address=/blinkbox.com/IPADD
address=/abc.com/IPADD
address=/fox.com/IPADD
address=/theplatform.com/IPADD
address=/nbc.com/IPADD
address=/nbcuni.com/IPADD
address=/ip2location.com/IPADD
address=/pbs.org/IPADD
address=/warnerbros.com/IPADD
address=/southpark.cc.com/IPADD
address=/cbs.com/IPADD
address=/brightcove.com/IPADD
address=/cwtv.com/IPADD
address=/spike.com/IPADD
address=/go.com/IPADD
address=/mtv.com/IPADD
address=/mtvnservices.com/IPADD
address=/playstation.net/IPADD
address=/uplynk.com/IPADD
address=/maxmind.com/IPADD
address=/disney.com/IPADD
address=/disneyjunior.com/IPADD
address=/xboxlive.com/IPADD
address=/lovefilm.com/IPADD
address=/turner.com/IPADD
address=/amctv.com/IPADD
address=/sho.com/IPADD
address=/mog.com/IPADD
address=/wdtvlive.com/IPADD
address=/beinsportsconnect.tv/IPADD
address=/beinsportsconnect.net/IPADD
address=/fig.bbc.co.uk/IPADD
address=/open.live.bbc.co.uk/IPADD
address=/sa.bbc.co.uk/IPADD
address=/www.bbc.co.uk/IPADD
address=/crunchyroll.com/IPADD
address=/ifconfig.co/IPADD
address=/omtrdc.net/IPADD' | \
sed -e "s/IPADD/$(wget -qO- ipv4.icanhazip.com)/g" > \
/etc/_configs/sni-dns.conf
wget \
https://raw.githubusercontent.com/X-DCB/netflix-proxy/master/docker-sniproxy/sniproxy.conf.template \
-qO /etc/_configs/sniproxy.conf
wget https://raw.githubusercontent.com/X-DCB/SmartDNS-one/master/docker.yaml -qO- | docker stack deploy -c - dnsx