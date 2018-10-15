#!/bin/bash
set -xeou pipefail

# This script is typically called from the 'docker.io/miabbott/piratemirror'
# container image, so there are some defaults that are assumed.
#
# You need to define a 'prod' and 'stage' directory for the script to run
# properly.  If you don't pass in those arguments to the script, it assumes
# you have your directories at '/host/{prod,stage}'.  This is because the
# script is normally executed in a container with directories bind mounted
# into the container at those locations.
#
# Additionally, you may set the location of the 'rsync-repos' script, but
# it defaults to '/root/rsync-repos' where it lives in the container

prod=${1:-/host/prod/}
stage=${2:-/host/stage/}
rsync_repos=${3:-/root/rsync-repos}

# We are now tracking Fedora 27 and 28 Atomic Workstation
releases=("27" "28" "29")

if [[ ! -d "$prod" ]] || [[ ! -d "$stage" ]]; then
    echo "Must have 'prod' and 'stage' directories present"
    exit 1
fi

# As new major releases are made available, we will need to sync the content
# for them as well.  Unfortunately, even though we are using a "unified"
# repo where all the refs are available from one URL, the content of each
# major release is signed by a different GPG key.  Until we can specify
# a list of GPG keys to use per remote (see: https://github.com/ostreedev/ostree/issues/773)
# we have to create a separate remote per release.
#
# So for each major release, we add the source of truth, mirror the latest
# commit, and prune anything older than 7 days.  Then we can generate the
# summary and rsync to prod.
#
# For Fedora 29 Silverblue, the ref got renamed, so we have to check which
# release version we are on and adjust.
#
for rel in "${releases[@]}"; do
  if (( "$rel" > 28 )); then
      ref=fedora/$rel/x86_64/silverblue
    else
      ref=fedora/$rel/x86_64/workstation
    fi
    gpgkeyname=RPM-GPG-KEY-fedora-$rel-primary
    remote=fedora-$rel-aw
    ostree --repo=$stage init --mode archive
    ostree --repo=$stage remote add --if-not-exists --set gpgkeypath=/etc/pki/rpm-gpg/$gpgkeyname $remote https://kojipkgs.fedoraproject.org/atomic/repo/
    ostree --repo=$stage pull --mirror --depth=1 $remote:$ref
    ostree --repo=$stage prune --keep-younger-than="7 days ago" $ref
done
ostree --repo=$stage summary -u
$rsync_repos --src $stage --dest $prod
