#
# Cookbook Name:: cncp-compute
# Recipe:: vm
#
# Copyright (C) 2016 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# ----- Basics -----

# Update the package structure
include_recipe 'apt::update'


# ----- Python and necessary packages -----

# Install a minimal global Python and virtualenv support
include_recipe "python::python"
include_recipe "python::virtualenv"

# Generally a good idea
package "pkg-config"

# Install libncurses development package (needed for IPython: see
# https://stackoverflow.com/questions/22892482/error-installing-gnureadline-via-pip)
package "libncurses5-dev"

# Fortran, BLAS, and LAPACK, needed for scipy to build reliably
package "gfortran"
package "libblas-dev"
package "liblapack-dev"

# SQLite for asynchronous parallel processing
package "sqlite"


# ----- Virtual environment -----

# Install a virtualenv with a known-good set of packages, using the
# version from the master github repo (annoyingly we can't copy from
# the local file tree within chef).
# 
# If we're building a simple compute server the virtualenv stuff is a
# bit redundant: we could just put it all globally.
python_virtualenv node['cncp-compute']['virtualenv'] do
  user node['cncp-compute']['username']
  dir  node['cncp-compute']['home']
  requirements node['cncp-compute']['requirements-uri']
end


# ----- Login -----

# Update .bashrc to drop the user straight into the virtualenv
if ::File.exists?("#{node['cncp-compute']['home']}/run_in_virtualenv.sh")
  Chef::Log.info ".bashrc already updated (probably)"
else
  # Create the activation script
  file "#{node['cncp-compute']['home']}/run_in_virtualenv.sh" do
    owner node['cncp-compute']['username']
    content "cd #{node['cncp-compute']['home']}/#{node['cncp-compute']['virtualenv']} ; . bin/activate"
  end

  # Source the activation script in .bashrc
  bash "update_bashrc" do
    cwd node['cncp-compute']['home']
    code <<-EOF
echo ". #{node['cncp-compute']['home']}/run_in_virtualenv.sh" >>#{node['cncp-compute']['home']}/.bashrc
EOF
  end
end

