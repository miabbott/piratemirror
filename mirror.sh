#!/bin/bash
set -xeou pipefail

# You need to define a 'prod' and 'stage' directory for the script to run
# properly.  If you don't pass in those arguments to the script, it assumes
# you have your directories at '/host/{prod,stage}'.  This is because the
# script is normally executed in a container with directories bind mounted
# into the container.
prod=${1:-/host/prod/}
stage=${2:-/host/stage/}
ref="fedora/27/x86_64/workstation"

if [[ ! -d "$prod" ]] || [[ ! -d "$stage" ]]; then
    echo "Must have 'staging' and 'repo' directories present"
    exit 1
fi

# Add the source of truth, mirror the latest commit, prune anything older
# than 7 days, generate the summary and then rsync to prod.
#
# NOTE: because this is typically run from a container, we assume the
# location of the 'rsync-repos' script
ostree --repo=$stage remote add --if-not-exists --set gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-27-primary onerepo https://kojipkgs.fedoraproject.org/atomic/repo/
ostree --repo=$stage pull --mirror --depth=1 onerepo:$ref
ostree --repo=$stage prune --keep-younger-than="7 days ago" $ref
ostree --repo=$stage summary -u
/root/rsync-repos --src $stage --dest $prod
