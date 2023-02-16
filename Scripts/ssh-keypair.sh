#!/bin/bash

# Generate the SSH keypair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ansible_id_rsa

# Set the correct permissions on the private key
chmod 600 ~/.ssh/ansible_id_rsa
