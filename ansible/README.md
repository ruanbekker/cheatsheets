# Ansible Cheatsheets

## Modules

Ping:

```
$ ansible all -m ping
```

Gather Facts:

```
$ ansible all -m gather_facts
```

Gather Facts for only one host:

```
$ ansible all -m gather_facts --limit 10.0.0.2
```

List Hosts:

```
$ ansible all --list-hosts
```

## Ad Hoc Commands

Update index repositories with apt

```
$ ansible all -m apt -a update_cache=true --become --ask-become-pass
```

Install packages with apt:

```
$ ansible all -m apt -a name=vim --become --ask-become-pass
```

Install the latest package with apt:

```
$ ansible all -m apt -a "name=vim state=latest" --become --ask-become-pass
```

Upgrade dist with apt:

```
$ ansible all -m apt -a upgrade=dist --become --ask-become-pass
```

## Playbooks

- `install_nginx.yml`

```yaml
---
- hosts: all
  become: true
  tasks:
    - name: install nginx
      apt:
        name: nginx
        state: latest
        update_cache: yes
      when: ansible_distribution in ["Debian", "Ubuntu"]
      
    - name: install nginx
      dnf:
        name: nginx
        state: latest
        update_cache: yes
      when: ansible_distribution == "CentOS"
```

Execute playbook:

```
$ ansible-playbook --ask-become-pass install_nginx.yml
```

## Refactoring Playbooks

Our `inventory`:

```
10.0.0.2 apache_package=apache2 php_package=libapache2-mod-php
10.0.0.3 apache_package=httpd php_package=php
```

Our `playbook.yml`:

```yaml
---
- hosts: all
  become: true
  tasks:
    - name: install apache
      package:
        name: 
          - "{{ apache_package }}"
          - "{{ php_package }}"
        state: latest
        update_cache: yes
```

## Target Specific Nodes

Our `inventory`:

```
[web_servers]
10.0.0.2
10.0.0.3

[db_servers]
10.0.0.4

[file_servers]
10.0.0.5
```

Our `playbook.yml`

```yaml
---
- hosts: all
  become: true
  tasks:
    - name: Install updates for CentOS 
      dnf:
        update_only: yes
        update_cache: yes
      when: ansible_distribution == "CentOS"
      
    - name: Install updates for Debian/Ubuntu 
      apt:
        upgrade: dist
        update_cache: yes
      when: ansible_distribution in ["Debian", "Ubuntu"]
````

## Resources

- [Automating App Build and Deployment from a Github Repository](https://medium.com/@rossbulat/ansible-automating-app-build-and-deployment-from-a-github-repository-7d613985f686)
- [Ansible Youtube Series @LearnLinuxTV](https://www.youtube.com/watch?v=EraC1AuWEF8)
