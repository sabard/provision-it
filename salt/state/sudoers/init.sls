sudo_users:
  group.present:
    - name: sudo
    - addusers:
    {% if pillar.get('sudoers') %}
      {% for u in pillar.get('sudoers') %}
        - {{u}}
      {% endfor %}
    {% endif %}
