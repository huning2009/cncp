#!/bin.bash

# baremetal.sh - install a compute server onto a remote machine

# Configuration
CHEF_CLIENT_URL=https://www.opscode.com/chef/install.sh
CNCP_REPO_URL=https://github.com/simoninireland/cncp.git
REPO=cncp
PASSWD=passwd.txt

# Tools
WGET=wget -O -
CHEF=chef-solo
GIT=git

# Install chef client
$WGET $CHEF_CLIENT_URL | bash

# Pull enough repo to provision the server, using a sparse checkout and
# shallow clone. See
# https://stackoverflow.com/questions/600079/is-there-any-way-to-clone-a-git-repositorys-sub-directory-only/13738951#13738951
$GIT init $REPO
(cd $REPO && \
    $GIT remote add origin $CNCP_REPO_URL &&
    $GIT config core.sparsecheckout true &&
    echo "vm/*" >> .git/info/sparse-checkout &&
    $GIT pull --depth=1 origin master)

# Now use chef to provision the machine using the cncp-compute::baremetal recipe
if [ -f "$PASSWD" ]; then
    cat $PASSWD | sudo -S $CHEF -c $REPO/vm/baremetal/solo.rb -j $REPO/vm/baremetal/solo.json
else


