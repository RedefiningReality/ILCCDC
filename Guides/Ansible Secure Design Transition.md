- replace the ansible.cfg file in /etc/ansible with [ansible2.cfg](../Ansible/config/ansible2.cfg)
  - if you followed the [Ansible installation guide](Ansible%20Installation.md), ansible2.cfg should be in /etc/ansible
- run `export EDITOR=nano ; ansible-vault create vault.yml`
- enter the following:
  - replace [password] with the Ansible password you chose when running secure-design.yml
  - replace [username] with the Ansible username you chose when running secure-design.yml (default kitten)
```
ansible_user: [user]
ansible_password: [password]
ansible_become_password: [password]
```
- ensure vault.yml is in the same directory as all other playbooks
- run all future ansible-playbook commands with the `--ask-vault-pass` option
