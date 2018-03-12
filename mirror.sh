#!/bin/bash
set -xeou pipefail

# You need to define a 'prod' and 'stage' directory for the script to run
# properly.  If you don't pass in those arguments to the script, it assumes
# you have your directories at '/host/{prod,stage}'.  This is because the
# script is normally executed in a container with directories bind mounted
# into the container.
prod=${1:-/host/prod}
stage=${2:-/host/stage}
ref="fedora/27/x86_64/workstation"

if [[ ! -d "$prod" ]] || [[ ! -d "$stage" ]]; then
    echo "Must have 'staging' and 'repo' directories present"
    exit 1
fi

# Here we add the source of truth for FAW and pull the latest commit from the
# newly added remote.  We store the commit id of HEAD for the remote ref and
# the local ref.
ostree --repo=$stage remote add --if-not-exists --set gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-27-primary onerepo https://kojipkgs.fedoraproject.org/atomic/repo/
ostree --repo=$stage pull --commit-metadata-only --depth=1 onerepo:$ref
rhead=$(ostree --repo=$stage rev-parse onerepo:$ref)
lhead=$(ostree --repo=$prod rev-parse $ref)

# If the two commit ids are different, we pull the content from the remote,
# prune the old data, generate a summary, then rsync from the 'stage' directory
# to the 'prod' directory.
#
# NOTE: because this script is typically invoked from a container, we are assuming
#       that the container has placed 'rsync-repos' in '/root'.  YMMV.
if [[ "$rhead" != "$lhead" ]]; then
    ostree --repo=$stage pull --mirror --depth=1 onerepo:$ref
    ostree --repo=$stage prune --keep-younger-than="7 days ago" $ref
    ostree --repo=$stage summary -u
    /root/rsync-repos --src $stage --dest $prod
fi
