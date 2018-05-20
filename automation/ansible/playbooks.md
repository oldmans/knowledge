
```yml
---
# 目标主机
- hosts: webservers
  remote_user: root
  become: yes
  become_method: sudo
  become_user: apache nobody
  become_flags:
  order: inventory reverse_inventory sorted reverse_sorted shuffle
  vars:
    http_port: 80
    max_clients: 200
    ansible_become:
    ansible_become_method:
    ansible_become_user:
    ansible_become_pass:
  vars_files:
    - vars/external_vars.yml
  tasks:
    - name: ensure apache is at the latest version
      yum: name=httpd state=latest
    - name: write the apache config file
      template: src=/srv/httpd.j2 dest=/etc/httpd.conf
      notify:
        - restart apache
    - name: ensure apache is running (and enable it at boot)
      service: name=httpd state=started enabled=yes
  handlers:
    - name: restart apache
      service: name=httpd state=restarted
```
