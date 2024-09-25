base:
    '*':
        - timezone-new_york
        - ssh-config
        - sudoers
        - pkg-gitlab-runner
        - grub-default
        - user-home

    'hostrole:coordinator':
        - match: pillar

    'hostrole:licorice':
        - match: pillar
        - grub-rt
        - pyenv
        - shielding
        - x-window-system
        - licorice
        - kernel-debug
