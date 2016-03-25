#
# Cookbook Name:: cncp-compute
# Recipe:: baremetal
#
# Copyright (C) 2016 Simon Dobson <simon.dobson@computer.org>
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# ----- Python and necessary packages -----

# Set up the right user etc
node.override[:cncp][:user] = node['baremetal_user']
node.override[:cncp][:dir] = node['baremetal_dir']

node.override[:python][:user] = node[:cncp][:user]
node.override[:python][:dir] = node[:cncp][:dir]
node.override[:python][:virtualenv] = node[:cncp][:virtualenv]
node.override[:python][:profile] = node[:cncp][:profile]

# Install a minimal global Python and virtualenv support
include_recipe "python::python"
include_recipe "python::virtualenv-tools"

# Generally a good idea
#package "pkg-config"

# Install libncurses development package (needed for IPython: see
# https://stackoverflow.com/questions/22892482/error-installing-gnureadline-via-pip)
package "ncurses-devel"

# Fortran, BLAS, and LAPACK, needed for scipy to build reliably
#package "gcc-fortran"
package "lapack"
package "lapack-devel"

# SQLite for asynchronous parallel processing
package "sqlite"


# ----- Virtual environment -----

# Install a virtualenv with a known-good set of packages, using the
# version from the master github repo
python_virtualenv node[:cncp][:virtualenv] do
  requirements node[:cncp][:requirements]
end


# ----- Compute engines -----

# Create an IPython parallel profile for the IPython version installed in the virtualenv
python_profile node[:cncp][:profile] do
  virtualenv node[:cncp][:virtualenv]
  parallel true
  ssh_server node[:cncp][:ssh_server]
end

# Start compute engines in this profile and virtualenv
python_compute "create_compute_engines" do
  virtualenv node[:cncp][:virtualenv]
  profile node[:cncp][:profile]
end


# ----- Login -----

# Update .bashrc to drop the user straight into the virtualenv
if ::File.exists?("#{node[:cncp][:dir]}/run_in_virtualenv.sh")
  Chef::Log.info ".bashrc already updated (probably)"
else
  # Create the activation script
  file "#{node[:cncp][:dir]}/run_in_virtualenv.sh" do
    owner node[:cncp][:user]
    content "cd #{node[:cncp][:dir]}/#{node[:cncp][:virtualenv]} ; . bin/activate"
  end

  # Source the activation script in .bashrc
  bash "update_bashrc" do
    cwd node[:cncp][:dir]
    code <<-EOF
echo ". #{node[:cncp][:dir]}/run_in_virtualenv.sh" >>#{node[:cncp][:dir]}/.bashrc
EOF
  end
end

