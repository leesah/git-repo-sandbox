## Usage

Simply start a container to use the sandbox.

    $ docker pull leesah/git-repo-sandbox
    $ docker run --interactive --tty leesah/git-repo-sandbox

## Experiments

### Workspace initialization

Initialize the workspace with all repositories on the master branch:

    developer:~$ repo init --manifest-url=/remotes/remote-00/manifest.git/
    developer:~$ repo sync

### Maintenance branch

Create a new maintenance branch from the current commit in every repository:

    developer:~$ repo forall --command 'git checkout -b v1_maint'
    developer:~$ repo forall --command 'git push --set-upstream $REPO_REMOTE v1_maint'

Create corresponding branch in the manifest:

    developer:~$ sed --in-place 's#master#v1_maint#' .repo/manifests/default.xml
    developer:~$ git -C .repo/manifests commit --message="New maintenance branch: v1_maint" default.xml
    developer:~$ git -C .repo/manifests push --set-upstream origin v1_maint

### Release tagging

Tag a release on the latest commit on a maintenance branch:

    developer:~$ repo init --manifest-url=/remotes/remote-00/manifest.git/ --manifest-branch=refs/heads/v1_maint
    developer:~$ repo sync
    developer:~$ repo forall --command 'git tag v1.1'
    developer:~$ repo forall --command 'git push --set-upstream $REPO_REMOTE v1.1'

Create corresponding tag in the manifest:

    developer:~$ sed --in-place 's#refs/heads/v1_maint#refs/tags/v1.1#' .repo/manifests/default.xml
    developer:~$ git -C .repo/manifests commit -m "New release v1.1" default.xml
    developer:~$ git -C .repo/manifests tag v1.1
    developer:~$ git -C .repo/manifests push -u origin v1.1

Checkout a certain release:

    developer:~$ repo init --manifest-url=/remotes/remote-00/manifest.git/ -b refs/tags/v1.1
    developer:~$ repo sync
