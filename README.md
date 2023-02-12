# ILCCDC
Repository for scripts and checklists for the Illinois Tech Cyberhawks CCDC team

### The Big Idea
Writing hardening scripts for every machine would require accessing each of them, downloading this repo, figuring out which script is relevant to each machine, and running only those. This seems unnecessarily time consuming, and gives red team a better chance of attacking us before all our hardening is complete.

*Instead*, access only the Ubuntu Workstation, install Ansible, and use Ansible scripts to harden all the other machines without having to touch them!
##### Potential Risks
If red team accesses the Ubuntu Workstation, they will have control over the network. To protect against this, we implement a firewall on the workstation that doesn't allow any incoming connections, and only allows outgoing connections on the ports specifically required for Ansible (tcp/22, tcp/5985, tcp/5986).

**Note:** You'll also have to check cron jobs to make sure there is no malware that's going to make outgoing connections on those ports.
