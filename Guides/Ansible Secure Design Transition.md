- replace the ansible.cfg file in /etc/ansible with [ansible2.cfg](../Ansible/config/ansible2.cfg)
  - if you followed the [Ansible installation guide](Ansible%20Installation.md), ansible2.cfg should be in /etc/ansible
- run `ansible-vault create vault.yml`
- enter the following, replacing [become password] with the Ansible password you chose when running secure-design.yml:

ansible_become_password: [become password]
- ensure vault.yml is in the same directory as all other playbooks
- run all future ansible-playbook commands with the `--ask-vault-pass` option
