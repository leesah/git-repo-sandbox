To start the sandbox container:

    $ docker run --rm -ti leesah/git-repo-sandbox

To initialize the workspace with all repositories on the master branch:

    developer:~$ repo init -u /remotes/remote-00/manifest.git/
    developer:~$ repo sync

To create a new maintenance branch from the current commit in every repository:

    developer:~$ repo forall -c git checkout -b ma162_maint
    developer:~$ repo forall -c 'git push -u $REPO_REMOTE ma162_maint'
    developer:~$ sed -i 's#master#ma162_maint#' .repo/manifests/default.xml
    developer:~$ git -C .repo/manifests commit -m "Created branch ma162_maint" default.xml
    developer:~$ git -C .repo/manifests push -u origin ma162_maint

To tag a release on the latest commit on a maintenance branch:

    developer:~$ repo init -u /remotes/remote-00/manifest.git/ -b refs/heads/ma162_maint
    developer:~$ repo sync
    developer:~$ repo forall -c git tag 162.0.1
    developer:~$ repo forall -c 'git push -u $REPO_REMOTE 162.0.1'
    developer:~$ sed -i 's#refs/heads/ma162_maint#refs/tags/162.0.1#' .repo/manifests/default.xml
    developer:~$ git -C .repo/manifests commit -m "Released 162.0.1" default.xml
    developer:~$ git -C .repo/manifests tag 162.0.1
    developer:~$ git -C .repo/manifests push -u origin 162.0.1
    
To checkout a certain release:

    developer:~$ repo init -u /remotes/remote-00/manifest.git/ -b refs/tags/162.0.1
    developer:~$ repo sync
