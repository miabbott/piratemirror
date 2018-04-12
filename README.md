https://faw.piratemirror.party/README.txt

This is a 'pirate' mirror of the Fedora 27/28 Atomic Workstation ostree
content.  It is not officially supported by Fedora, Project Atomic, or
any other organization in any way.

This mirror is located in a datacenter in Amsterdam, Netherlands.

It aims to have the last 7 days worth of ostree commits available.

**!!! WARNING !!!   !!! WARNING !!!   !!! WARNING !!!    !!! WARNING  !!!**

Please do not rely on this mirror for any kind of production infrastructure!

This mirror has no uptime guarantee and may disappear without warning if
the monetary cost or maintenance cost becomes too great.

You have been warned!

**!!! WARNING !!!   !!! WARNING !!!   !!! WARNING !!!    !!! WARNING  !!!**

In order to use this repo, you'll need to configure a remote with the
proper GPG key for each release:

Fedora 27 Atomic Workstation

```
# ostree remote add --set gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-27-primary pirate-27 https://faw.piratemirror.party
# rpm-ostree rebase pirate-27:fedora/27/x86_64/workstation
```

Fedora 28 Atomic Workstation

```
# ostree remote add --set gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-28-primary pirate-28 https://faw.piratemirror.party
# rpm-ostree rebase pirate-28:fedora/28/x86_64/workstation
```

---
Say hello:  miabbott #atomic Freenode | https://twitter.com/rageear

