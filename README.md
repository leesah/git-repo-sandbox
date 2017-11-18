To start the sandbox container:

    $ docker run --rm -ti leesah/git-repo-sandbox

To initialize the workspace with all repositories on the master branch:

    developer:~$ repo init -u /remotes/remote-00/manifest.git/
    developer:~$ repo sync

To create a new maintenance branch from the current commit in every repository:

    developer:~$ repo forall -c git checkout -b v1_maint
    developer:~$ repo forall -c 'git push -u $REPO_REMOTE v1_maint'
    developer:~$ sed -i 's#master#v1_maint#' .repo/manifests/default.xml
    developer:~$ git -C .repo/manifests commit -m "New maintenance branch: v1_maint" default.xml
    developer:~$ git -C .repo/manifests push -u origin v1_maint

To tag a release on the latest commit on a maintenance branch:

    developer:~$ repo init -u /remotes/remote-00/manifest.git/ -b refs/heads/v1_maint
    developer:~$ repo sync
    developer:~$ repo forall -c git tag v1.1
    developer:~$ repo forall -c 'git push -u $REPO_REMOTE v1.1'
    developer:~$ sed -i 's#refs/heads/v1_maint#refs/tags/v1.1#' .repo/manifests/default.xml
    developer:~$ git -C .repo/manifests commit -m "New release v1.1" default.xml
    developer:~$ git -C .repo/manifests tag v1.1
    developer:~$ git -C .repo/manifests push -u origin v1.1
    
To checkout a certain release:

    developer:~$ repo init -u /remotes/remote-00/manifest.git/ -b refs/tags/v1.1
    developer:~$ repo sync
