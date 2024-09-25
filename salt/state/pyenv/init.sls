pyenv-deps:
    pkg.installed:
        - pkgs:
            - build-essential
            - libssl-dev
            - zlib1g-dev
            - libbz2-dev
            - libreadline-dev
            - libsqlite3-dev
            - curl
            - libncursesw5-dev
            - xz-utils
            - tk-dev
            - libxml2-dev
            - libxmlsec1-dev
            - libffi-dev
            - liblzma-dev

pyenv:
    pyenv.installed:
        - name: python-3.8.12
        - default: True
        - user: lico
        - require:
            - pkg: pyenv-deps
            - sls: user-home

pyenv-virtualenv:
    git.latest:
        - name: https://github.com/pyenv/pyenv-virtualenv.git
        - target: /home/lico/.pyenv/plugins/pyenv-virtualenv
        - user: lico
        - require:
            - pyenv


enable-pyenv-bashrc:
    file.append:
        - name: /home/lico/.bashrc
        - source: https://raw.githubusercontent.com/bil/licorice/main/install/pyenv_config.sh
        - source_hash: 7e60115a0e578474d41f82383f92eee3f34ebf813cedf2955249ad538e45e0a1

enable-python-bashrc-noninteractive:
    # enable python in non-interactive shells
    file.replace:
        - name: /home/lico/.bashrc
        - pattern: ^case \$- in\s*\*i\*\) ;;\s*\*\) return;;\s*esac
        - repl: "# REMOVED BY SALT"

    # TODO this would be nice if supported
    # file.comment:
        # - regex: ^case \$- in\s*\*i\*\) ;;\s*\*\) return;;\s*esac
