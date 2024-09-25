/home/lico/:
  file.directory:
    - user: lico
    - group: lico
    - mode: 755 # some permission
    - recurse:
      - user
      - group
