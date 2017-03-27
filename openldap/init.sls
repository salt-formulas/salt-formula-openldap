include:
  {%- if pillar.openldap.client is defined %}
  - openldap.client
  {%- endif %}
