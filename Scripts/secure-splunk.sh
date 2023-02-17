#!/bin/bash

# SSH version 5 has RCE -> disable altogether
service sshd stop
rm /etc/init.d/sshd

# Remove firewall rules
iptables -F

# Only allow incoming traffic on tcp/8000, tcp/8189, tcp/9997, udp/514, ping
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
iptables -A INPUT -p tcp --dport 8189 -j ACCEPT
iptables -A INPUT -p tcp --dport 9997 -j ACCEPT
iptables -A INPUT -p udp --dport 514 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -P INPUT DROP

# Block all outgoing traffic except for established connections
iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -P OUTPUT DROP
