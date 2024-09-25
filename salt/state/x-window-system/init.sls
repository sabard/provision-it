x-window-system-pkgs:
    pkg.installed:
        - pkgs:
            - xinit
            - openbox
            - lxterminal


/home/lico/.xinitrc:
    file.managed:
        - source: salt://x-window-system/.xinitrc
