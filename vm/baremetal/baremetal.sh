#!/bin/bash

# baremetal.sh - install a compute server onto a remote machine

# Configuration
CHEF_CLIENT_URL=https://www.opscode.com/chef/install.sh
CNCP_REPO_URL=https://github.com/simoninireland/cncp.git
REPO=cncp
PASSWD=passwd.txt

# Tools
WGET="wget -O -"
CHEF=chef-solo
GIT=git

# Install chef client if needed
if [ `which $CHEF` ]; then
    echo "Using installed version of chef"
else
    $WGET $CHEF_CLIENT_URL | bash
fi

# Get the provisioning system from the cncp git repo
if [ -d "$REPO" ]; then
    echo "Using installed repository"
else
    # Pull only enough repo to provision the server, using a sparse checkout and
    # shallow clone so we don't pull the entire book. See
    # https://stackoverflow.com/questions/600079/is-there-any-way-to-clone-a-git-repositorys-sub-directory-only/13738951#13738951
    $GIT init $REPO
    (cd $REPO && \
	$GIT remote add origin $CNCP_REPO_URL &&
	$GIT config core.sparsecheckout true &&
	echo 'vm/*' >> .git/info/sparse-checkout &&
	$GIT pull --depth=1 origin master)
fi

# Now use chef to provision the machine using the cncp-compute::baremetal recipe
if [ -f "$PASSWD" ]; then
    cat $PASSWD | sudo -S $CHEF -c $REPO/vm/baremetal/solo.rb -j $REPO/vm/baremetal/solo.json
else
    sudo $CHEF -c $REPO/vm/baremetal/solo.rb -j $REPO/vm/baremetal/solo.json
fi

