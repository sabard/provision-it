sshd:
    service.running:
        - watch:
            - file: /etc/ssh/sshd_config.d/10-bil-sshd.conf
    file.managed:
        - name: /etc/ssh/sshd_config.d/10-bil-sshd.conf
        - source: salt://ssh-config/10-bil-sshd.conf
        - user: root
        - group: root
        - mode: 644
