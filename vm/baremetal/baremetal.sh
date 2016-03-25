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

# Install chef client
if [ `which $CHEF` ]; then
    echo "Using installed version of chef"
else
    $WGET $CHEF_CLIENT_URL | bash
fi

# Pull enough repo to provision the server, using a sparse checkout and
# shallow clone. See
# https://stackoverflow.com/questions/600079/is-there-any-way-to-clone-a-git-repositorys-sub-directory-only/13738951#13738951
if [ -d "$REPO" ]; then
    echo "Using installed repository"
else
    $GIT init $REPO
    (cd $REPO && \
	$GIT remote add origin $CNCP_REPO_URL &&
	$GIT config core.sparsecheckout true &&
	echo 'vm/*' >> .git/info/sparse-checkout &&
	$GIT pull --depth=1 origin master)
fi

# Set up the chef driver files
cat >solo.rb <<EOF
file_cache_path '$PWD'
cookbook_path '$PWD/cncp/vm/provisioning/cookbooks/'
EOF
cat >solo.json <<EOF
{
  "baremetal_user": "$USER",
  "baremetal_dir": "$PWD",
  "run_list": [ "recipe[cncp-compute::baremetal]" ]
}
EOF

# Now use chef to provision the machine using the cncp-compute::baremetal recipe
if [ -f "$PASSWD" ]; then
    # we have a root password in a file: handy but insecure
    cat $PASSWD | sudo -S $CHEF -c solo.rb -j solo.json
else
    # we might ask for the root password: secure but annoying/impossible
    sudo $CHEF -c solo.rb -j solo.json
fi


