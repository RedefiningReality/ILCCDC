# ILCCDC
Repository for scripts and checklists for the Illinois Tech Cyberhawks CCDC team

## The Big Idea
Writing hardening scripts for every machine would require accessing each of them, downloading this repo, figuring out which script is relevant to each machine, and running only those. This seems unnecessarily time consuming, and gives red team a better chance of attacking us before all our hardening is complete.
*Instead*, access only the external Windows 10, install Ansible, and use Ansible scripts to harden all the other machines without having to touch them!

### How It Works
Default configurations will allow SSH via password on Linux machines and will allow WinRM over HTTP via NTLM authentication on Windows machines. There are more secure options out there than these, so we will use these to initially connect to the machines and configure them to use the more secure options (SSH via key-based authenticaiton on Linux and WinRM over HTTPS via CredSSP on Windows). From there, the Ansible configurations on the Windows 10 will have to be updated accordingly, and we can use the more secure connections to execute scripts moving forward.

This means there are going to be two Ansible configurations:
#### Ansible (insecure design)
- Linux: SSH (tcp/22) via password authentication
  - Access root user via become where sudo is supported
  - Access root user via su where sudo is not supported
- Windows: WinRM over HTTP (tcp/5985) via NTLM authentication
#### Ansible (secure design)
- Linux: SSH (tcp/22) via key-based authentication
  - Access root user via become on all hosts
- Windows: WinRM over HTTPS (tcp/5986) via CredSSP

### Potential Risks
If red team accesses the Windows 10, they will have control over the network. To protect against this, we implement a firewall on the Windows 10 that doesn't allow any incoming connections and only allows outgoing connections on the ports specifically required for Ansible (tcp/22, tcp/5985, tcp/5986).

**Note:** You'll also have to check cron jobs to make sure there is no malware or other programs that are going to make outgoing connections on those ports.

## Competition Day Checklist
*to be edited*

**Note:** I might decide to put all Ansible configurations in an inconspicuous hidden directory just in case red team makes it onto the Windows 10 (although that should be impossible). I still haven't decided whether or not this is worth it. The following instructions assume I don't do that.
1. Add Windows 10 Internal, User, and Public NAT rules to the Palo Alto to allow the Windows 10 to be in the same subnet as the other hosts.
2. Download this repo on the Windows 10 and unzip it. Also install [Wise Folder Hider](https://www.wisecleaner.com/wise-folder-hider.html) for step 9.
3. Install WSL, Debian, and Ansible as explained in the [Ansible installation guide](Guides/Ansible%20Installation.md).
4. Prepare all the hosts for communicating with Ansible as explained in [Ansible prep guide](Guides/Ansible%20Preparation.md).
5. Copy files from the Ansible/config/insecure directory to /etc/ansible on the Windows 10 WSL Debian.
6. Run `ansible-playbook secure-design.yml -e "password=[password]"` on the Windows 10 WSL. Replace [password] with your desired password for the Ansible user. This will transition all hosts except Splunk from Ansible (insecure design) as defined above to Ansible (secure design) as defined above.
7. Run secure-splunk.sh on the Splunk machine. This will disable SSH (outdated and vulnerable to RCE) and firewall every port except those required to access the web UI. It will also only make the web UI accessible from one of the internal machines.
8. Run `ansible-playbook master.yml` on the Windows 10 WSL. This is a master playbook that will call all the other playbooks required to harden the hosts.
9. Create a password-locked (vault) folder using the instructions in the [Windows 10 vault guide](Guides/Windows%2010%20Vault.md), and move passwords.txt and old_passwords.txt to this folder.
10. Implement Windows 10 firewall to block all incoming connections and only allow outgoing connections on ports tcp/22 and tcp/5986. I have yet to decide how to approach this.
11. Implement Palo Alto firewall rules and fix DHCP as defined in [Network Information.pdf](Network%20Information.pdf).
12. Change Palo Alto SSH password and GUI password.
