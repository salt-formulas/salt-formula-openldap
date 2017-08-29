openldap:
  client:
    server:
      basedn: dc=example,dc=local
      host: ldap.example.local
      tls: true
      port: 389
      auth:
        user: cn=admin,dc=example,dc=local
        password: dummypass
    entry:
      people:
        type: ou
        classes:
          - top
          - organizationalUnit
        entry:
          jdoe:
            type: cn
            # Change attributes that already exists with different content
            action: replace
            # Delete all other attributes
            purge: true
            attr:
              uid: jdoe
              uidNumber: 20001
              gidNumber: 20001
              gecos: John Doe
              givenName: John
              sn: Doe
              homeDirectory: /home/jdoe
              loginShell: /bin/bash
            classes:
              - posixAccount
              - inetOrgPerson
              - top
              - ldapPublicKey
              - shadowAccount
          karel:
            # Simply remove cn=karel
            type: cn
            enabled: false