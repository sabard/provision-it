shielding-deps:
  pkg.installed:
      - pkgs:
          - cpuset

irqbalance-banned-cpus:
  file.replace:
    - name: /etc/default/irqbalance
    - pattern: ^#IRQBALANCE_BANNED_CPUS.*
    # TODO should be dependent on number of CPUs
    - repl: IRQBLANCE_BANNED_CPUS=0000000e

systemctl restart irqbalance:
  cmd.run:
    - require:
      - irqbalance-banned-cpus
