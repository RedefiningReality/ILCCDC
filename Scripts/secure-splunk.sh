#!/bin/bash

# SSH version 5 has RCE -> disable altogether
service sshd stop
rm /etc/init.d/sshd

# Fix firewall rules
iptables -F
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
iptables -A INPUT -p tcp --dport 8189 -j ACCEPT
iptables -A INPUT -p tcp --dport 9997 -j ACCEPT
iptables -A INPUT -p udp --dport 514 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -P INPUT DROP
