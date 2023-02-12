### Ansible Configurations
- Test ansible.cfg file: `ansible-config dump --only-changed`
- Test inventory (hosts) file: `ansible-inventory -i [file] --list`

### Ping
- Linux: `ansible linux -m ping`
- Windows: `ansible windows -m win_ping`

### Command
- Linux: `ansible linux -m shell -a "[command]"`
- Windows: `ansible windows -m win_shell -a "[command]"`

### Playbook
- `ansible-playbook [playbook].yml`
- `ansible-playbook -i [hosts file] [playbook].yml --[variable]=[value]`
