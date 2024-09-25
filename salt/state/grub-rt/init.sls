grub-cmdline:
  file.replace:
    - name: /etc/default/grub
    - pattern: GRUB_CMDLINE_LINUX_DEFAULT=.*
    # TODO add maybe-ubiquity for 20.04
    - repl: GRUB_CMDLINE_LINUX_DEFAULT="pci=nomsi systemd.unified_cgroup_hierarchy=false isolcpus=nohz,domain,managed_irq,1-3 nohz_full=1-3"

update-grub:
  cmd.run:
    - require:
      - grub-cmdline
