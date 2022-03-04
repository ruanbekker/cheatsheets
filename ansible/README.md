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
# pretasks mandates to run before any other tasks are running
# but ansible runs playbooks from top to bottom
- hosts: all
  become: true
  pre_tasks:
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
      
# package is used when the name of the package is the same 
# across operating systems
- hosts: web_servers
  become: true
  tasks:
    - name: Install Nginx
      package:
        name:
          - nginx
          - apache2-utils
        state: latest
      
- hosts: db_servers
  become: true
  tasks:
    - name: Install MariaDB for CentOS 
      dnf:
        name: mariadb-server
        state: latest
      when: ansible_distribution == "CentOS"
      
    - name: Install MariaDB for Debian/Ubuntu 
      apt:
        name: mariadb
        state: latest
      when: ansible_distribution in ["Debian", "Ubuntu"]
      
- hosts: file_servers
  become: true
  tasks:
    - name: Install Samba 
      package:
        name: samba
        state: latest
````

Then run it with:

```bash
$ ansible-playbook --ask-become-pass playbook.yml
```

## Metadata with Tags 

Use tags to only target specific targets.

```yaml
---
- hosts: all
  become: true
  pre_tasks:
  
    - name: Install updates for CentOS 
      tags: always
      dnf:
        update_only: yes
        update_cache: yes
      when: ansible_distribution == "CentOS"
      
    - name: Install updates for Debian/Ubuntu
      tags: always
      apt:
        upgrade: dist
        update_cache: yes
      when: ansible_distribution in ["Debian", "Ubuntu"]

- hosts: web_servers
  become: true
  tasks:
  
    - name: Install Nginx and utilities for CentOS 
      tags: nginx,centos
      dnf:
        name:
          - nginx
          - httpd-tools
      when: ansible_distribution == "CentOS"  
  
    - name: Install Nginx and utilities for Ubuntu
      tags: nginx,ubuntu
      apt:
        name:
          - nginx
          - apache2-utils
        state: latest
      when: ansible_distribution in ["Debian", "Ubuntu"]
      
- hosts: db_servers
  become: true
  tasks:
  
    - name: Install MariaDB for CentOS 
      tags: centos,db,mariadb
      dnf:
        name: mariadb-server
        state: latest
      when: ansible_distribution == "CentOS"
      
    - name: Install MariaDB for Debian/Ubuntu
      tags: ubuntu,db,mariadb
      apt:
        name: mariadb
        state: latest
      when: ansible_distribution in ["Debian", "Ubuntu"]
      
- hosts: file_servers
  become: true
  tasks:
  
    - name: Install Samba 
      tags: samba
      package:
        name: samba
        state: latest
```

To run the playbook against all targets specified in the playbooks:

```bash
$ ansible-playbook --ask-become-pass playbook.yml
```

To list all the tags in the playbook:

```bash
$ ansible-playbook --list-tags playbook.yml

playbook: playbook.yml

  play #1 (all): all  TAGS: []
      TASK TAGS: [always]
  
  play #2 (web_servers): all  TAGS: []
      TASK TAGS: [nginx, ubuntu, centos]
      
  play #3 (db_servers): all  TAGS: []
      TASK TAGS: [centos, db, mariadb, ubuntu]
      
  play #4 (file_servers): all  TAGS: []
      TASK TAGS: [samba]
      
```

To only target the tasks with the ubuntu tag, (note: the updates task will still run due to the `always` tag):

```bash
$ ansible-playbook --tags ubuntu --ask-become-pass playbook.yml
```

For targeting multiple tags:

```bash
$ ansible-playbook --tags "db,ubuntu" --ask-become-pass playbook.yml
```

## Resources

- [Automating App Build and Deployment from a Github Repository](https://medium.com/@rossbulat/ansible-automating-app-build-and-deployment-from-a-github-repository-7d613985f686)
- [Ansible Youtube Series @LearnLinuxTV](https://www.youtube.com/watch?v=3RiVKs8GHYQ&list=PLT98CRl2KxKEUHie1m24-wkyHpEsa4Y70&index=1)
