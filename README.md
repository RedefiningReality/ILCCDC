# ILCCDC
Repository for scripts and checklists for the Illinois Tech Cyberhawks CCDC team

### The Big Idea
Writing hardening scripts for every machine would require accessing each of them, downloading this repo, figuring out which script is relevant to each machine, and running only those. This seems unnecessarily time consuming, and gives red team a better chance of attacking us before all our hardening is complete.
*Instead*, access only the Ubuntu Workstation, install Ansible, and use Ansible scripts to harden all the other machines without having to touch them!

#### How It Works
Default configurations will allow SSH via password on Linux machines and will allow WinRM over HTTP via NTLM authentication on Windows machines. There are more secure options out there than these, so we will use these to initially connect to the machines and configure them to use the more secure options (SSH via key-based authenticaiton on Linux and WinRM over HTTPS via CredSSP on Windows). From there, the Ansible configurations on the Ubuntu Workstation will have to be updated accordingly, and we can use the more secure connections to execute scripts moving forward.

This means there are going to be two Ansible configurations:
##### Ansible (insecure design)
- Linux: SSH (tcp/22) via password authentication
  - Access root user via become where sudo is supported
  - Access root user via su where sudo is not supported
- Windows: WinRM over HTTP (tcp/5985) via NTLM authentication
##### Ansible (secure design)
- Linux: SSH (tcp/22) via key-based authentication
  - Access root user via sudo
- Windows: WinRM over HTTPS (tcp/5986) via CredSSP

#### Potential Risks
If red team accesses the Ubuntu Workstation, they will have control over the network. To protect against this, we implement a firewall on the workstation that doesn't allow any incoming connections and only allows outgoing connections on the ports specifically required for Ansible (tcp/22, tcp/5985, tcp/5986).

**Note:** You'll also have to check cron jobs to make sure there is no malware or other programs that are going to make outgoing connections on those ports.

### Competition Day Checklist
*to be edited*

**Note:** I might decide to put all Ansible configurations in an inconspicuous hidden directory just in case red team makes it onto the Ubuntu Workstation (although that should be impossible). I still haven't decided whether or not this is worth it. The following instructions assume I don't do that.
1. Run `install-ansible.sh` on the Ubuntu Workstation. This will do the following:
   1. Ensure the workstation is using the latest Ubuntu repositories
   2. Update Python3 using apt
   3. Install Ansible using the Python3 pip module
   4. Copy the correct ansible.cfg and hosts (inventory) files to the /etc/ansible directory
   5. Implement ufw firewall rules to only allow outgoing connections on tcp/22 and tcp/5985
2. Configure the Palo Alto firewall as defined in Network Configuration.pdf
   - Tasks 1 and 2 can be completed simultaneously by two different team members
3. Run `ansible-playbook secure-design.yml` on the Ubuntu Workstation
This will transition from Ansible (insecure design) as defined above to Ansible (secure design) as defined above.
5. Run `ansible-playbook harden.yml` on the Ubuntu Workstation
This is a master playbook that will call all the other playbooks required to harden the machines.
