licorice-pkgs:
    pkg.installed:
        - pkgs:
            - make
            - gdb
            - wget
            - htop
            - tmux
            - vim
            - libevent-dev
            - libsqlite3-dev
            - libmsgpack-dev
            - libopenblas-base
            - libopenblas-dev
            - gfortran
            - sqlite3

licorice-repo:
    git.latest:
        - name: https://github.com/bil/licorice
        - target: /home/lico/licorice
        - rev: sabard/salt
        - user: lico
        - fetch_tags: True
        - force_fetch: True
        - force_reset: True
        - require:
            - sls: user-home
            - licorice-pkgs

licorice-pyenv-venv:
    file.managed:
        - name: /home/lico/licorice/.python-version
        - source: salt://licorice/.python-version
        - user: lico
        - group: lico
        - require:
            - sls: pyenv

licorice-install:
    cmd.run:
        - name: /home/lico/licorice/install/env_setup.sh
        - runas: lico
        - env:
            - LICO_SKIP_DEPS: 1
        - shell: /bin/bash
        - cwd: /home/lico/licorice
        - require:
            - licorice-repo
            - licorice-pyenv-venv
            - sls: pyenv

licorice-permissions:
    file.managed:
        - name: /etc/security/limits.d/licorice.conf
        - source: salt://licorice/limits.conf

licorice-groups:
    user.present:
        - name: lico
        - groups:
            - lp
        - remove_groups: False

# licorice-irqs:
# set IRQBALANCE_BANNED_CPUS in /etc/default/irqbalance
# sudo systemctl restart irqbalance
# run licorice irqbalance util script

# licorice-mtu:
# add mtu: "9000" to /etc/netplan/01-netcfg.yaml
# add:
# net.core.rmem_max=26214400
# net.core.rmem_default=26214400
# to /etc/sysctl.conf
# reboot or run:
# sudo sysctl -w net.core.rmem_max=26214400
# sudo sysctl -w net.core.rmem_default=26214400

# licorice-softirqs:


# Notes
# remove unattended-upgrades: sudo apt remove unattended-upgrades
# killed extra processes on cores 1-3: salt-minion, polkitd?, etc.



