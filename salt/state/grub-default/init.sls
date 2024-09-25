grub-nosplash:
  file.replace:
    - name: /etc/default/grub
    - pattern: quiet splash
    - repl: nosplash

grub-timeout-menu:
  file.replace:
    - name: /etc/default/grub
    - pattern: GRUB_TIMEOUT_STYLE=hidden
    - repl: GRUB_TIMEOUT_STYLE=menu

grub-timeout-5:
  file.replace:
    - name: /etc/default/grub
    - pattern: GRUB_TIMEOUT=0
    - repl: GRUB_TIMEOUT=5

grub-cmdline:
  file.replace:
    - name: /etc/default/grub
    - pattern: GRUB_CMDLINE_LINUX_DEFAULT=.*
    # TODO add maybe-ubiquity for 20.04
    - repl: GRUB_CMDLINE_LINUX_DEFAULT="systemd.unified_cgroup_hierarchy=false"

update-grub:
  cmd.run:
    - require:
      - grub-nosplash
      - grub-timeout-menu
      - grub-timeout-5
      - grub-cmdline
