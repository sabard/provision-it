wait_for_reboot:
  loop.until_no_eval:
    - name: cmd.run
    - expected: 'False'
    - period: 5
    - timeout: 20
    - args:
      - ssh 172.17.3.21 -l lico
