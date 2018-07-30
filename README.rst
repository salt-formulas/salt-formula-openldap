========
Usage
========

Sample pillars
==============

Client
------

.. code-block:: yaml

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

Read more
=========

- https://docs.saltstack.com/en/latest/ref/states/all/salt.states.ldap.html#manage-entries-in-an-ldap-database

Documentation and bugs
======================

* http://salt-formulas.readthedocs.io/
   Learn how to install and update salt-formulas

* https://github.com/salt-formulas/salt-formula-openldap/issues
   In the unfortunate event that bugs are discovered, report the issue to the
   appropriate issue tracker. Use the Github issue tracker for a specific salt
   formula

* https://launchpad.net/salt-formulas
   For feature requests, bug reports, or blueprints affecting the entire
   ecosystem, use the Launchpad salt-formulas project

* https://launchpad.net/~salt-formulas-users
   Join the salt-formulas-users team and subscribe to mailing list if required

* https://github.com/salt-formulas/salt-formula-openldap
   Develop the salt-formulas projects in the master branch and then submit pull
   requests against a specific formula

* #salt-formulas @ irc.freenode.net
   Use this IRC channel in case of any questions or feedback which is always
   welcome

