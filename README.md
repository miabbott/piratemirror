https://faw.piratemirror.party/README.txt

This is a 'pirate' mirror of the Fedora 27 Atomic Workstation ostree
content.  It is not officially supported by Fedora, Project Atomic, or
any other organization in any way.

This mirror is located in a datacenter in Amsterdam, Netherlands.

It aims to have the last 7 days worth of ostree commits available.

*!!! WARNING !!!   !!! WARNING !!!   !!! WARNING !!!    !!! WARNING  !!!*

Please do not rely on this mirror for any kind of production infrastructure!

This mirror has no uptime guarantee and may disappear without warning if
the monetary cost or maintenance cost becomes too great.

You have been warned!

*!!! WARNING !!!   !!! WARNING !!!   !!! WARNING !!!    !!! WARNING  !!!*

In order to use this repo:

```
# ostree remote add --set gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-27-primary pirate https://faw.piratemirror.party
# rpm-ostree rebase pirate:fedora/27/x86_64/workstation
```

---
Say hello:  miabbott #atomic Freenode | https://twitter.com/rageear

