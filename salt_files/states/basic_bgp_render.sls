{% set hostname = grains.get('host') %}
render the output:
  file.managed:
    - name: /srv/salt/templates/intended/configs/{{ hostname }}.cfg
    - source: /srv/salt/templates/basic_bgp.j2
    - template: jinja
