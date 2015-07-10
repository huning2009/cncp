#
# Cookbook Name:: cncp-compute
# Recipe:: default
#
# Copyright (C) 2015 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# User, home directory, virtualenv and its requirements
# (Easier to maintain them here than as attributes)
cncp_user = "vagrant"
cncp_user_home = "/home/#{cncp_user}"
cncp_virtualenv = "cncp-compute"
cncp_compute_requirements = "https://raw.githubusercontent.com/simoninireland/cncp/master/cncp-compute-requirements.txt"

# Update the package structure
include_recipe 'apt::update'

# Install a minimal global Python and virtualenv support
include_recipe "python::python"
include_recipe "python::virtualenv"

# Install libncurses development package (needed for IPython: see
# https://stackoverflow.com/questions/22892482/error-installing-gnureadline-via-pip)
package "libncurses5-dev"

# Fortran, BLAS, and LAPACK, needed for scipy to build reliably
package "gfortran"
package "libblas-dev"
package "liblapack-dev"

# Install a virtualenv with a known-good set of packages, using the
# version from the master github repo (annoyingly we can't copy from
# the local file tree within chef).
# 
# If we're building a simple compute server the virtualenv stuff is a
# bit redundant: we could just put it all globally.
python_virtualenv "#{cncp_virtualenv}" do
  user cncp_user
  dir cncp_user_home
  requirements cncp_compute_requirements
end

# Update .bashrc to drop the user straight into the virtualenv
if ::File.exists?("#{cncp_user_home}/run_in_virtualenv.sh")
  Chef::Log.info ".bashrc already updated (probably)"
else
  # Create the activation script
  file "#{cncp_user_home}/run_in_virtualenv.sh" do
    owner cncp_user
    content "cd #{cncp_user_home}/#{cncp_virtualenv} ; . bin/activate"
  end

  # Source the activation script in .bashrc
  bash "update_bashrc" do
    cwd cncp_user_home
    code <<-EOF
echo ". #{cncp_user_home}/run_in_virtualenv.sh" >>#{cncp_user_home}/.bashrc
EOF
  end
end

