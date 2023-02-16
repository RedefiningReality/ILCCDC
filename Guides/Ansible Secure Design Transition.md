- replace the ansible.cfg file with ansible2.cfg
- run `ansible-vault create vault.yml`
- enter the following, replacing [become password] with the password that was printed after running secure-design.yml:

ansible_become_password: [become password]
- ensure vault.yml is in the same directory as all other playbooks
- run all future ansible-playbook commands with the `--ask-vault-pass` option
