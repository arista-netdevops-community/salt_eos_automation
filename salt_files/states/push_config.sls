{% set hostname = grains.get('host') %}
pyeapi.config:
  module.run:
    - config_file: /srv/salt/templates/intended/configs/{{hostname}}.cfg