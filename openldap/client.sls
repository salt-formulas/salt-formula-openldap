{%- from "openldap/map.jinja" import client with context %}

{%- if client.enabled|default(True) %}

openldap_packages:
  pkg.installed:
    - names: {{ client.pkgs }}

/etc/salt/minion.d/_ldap.conf:
  file.managed:
  - source: salt://openldap/files/_ldap.conf
  - template: jinja

{%- if client.entry is defined %}

{%- macro process_entry(entry, tree) %}
  {%- for name, param in entry.iteritems() %}
    {%- set dn = param.get('type', 'cn') + "=" + name + "," + tree %}

openldap_client_{{ dn }}:
  ldap.managed:
    - connect_spec:
        url: ldap://{{ client.server.host }}{% if client.server.port is defined %}:{{ client.server.port }}{% endif %}
        {%- if client.server.auth is defined %}
        bind:
          method: simple
          dn: {{ client.server.auth.user }}
          password: {{ client.server.auth.password }}
        {%- endif %}
        {%- if client.server.get('tls', False) %}
        tls:
          starttls: true
        {%- endif %}
    - entries:
      - {{ dn }}:
        {%- if param.get('enabled', True) %}
        - delete_others: {{ param.get('purge', False) }}
        - {{ param.get('action', 'replace') }}:
            {{ param.get('type', 'cn') }}: {{ name }}
            {%- for k, v in param.get('attr', {}).iteritems() %}
            {{ k }}: {{ v|yaml }}
            {%- endfor %}
            objectClass: {{ param.get('classes', [])|yaml }}
            {%- if param.member is defined %}
            member:
              {%- for member in param.get('member', []) %}
              - {{ member }}{% if member.split(',')[-1].split('=')[0] != 'dc' %},{{ client.server.basedn }}{% endif %}
              {%- endfor %}
            {%- endif %}
        {%- else %}
        - delete_others: true
        {%- endif %}
    {%- if tree.split(',')[-1].split('=')[0] != 'dc' %}
    - require:
      - ldap: openldap_client_{{ tree }}
      {%- for member in param.get('member', []) %}
      - ldap: openldap_client_{{ member }}{% if member.split(',')[-1].split('=')[0] != 'dc' %},{{ client.server.basedn }}{% endif %}
      {%- endfor %}
    {%- endif %}

    {%- if param.entry is defined %}
{{ process_entry(param.entry, param.get('type', 'cn') + "=" + name + "," + tree) }}
    {%- endif %}
  {%- endfor %}
{%- endmacro %}

{{ process_entry(client.entry, client.server.basedn) }}

{%- endif %}

{%- endif %}
