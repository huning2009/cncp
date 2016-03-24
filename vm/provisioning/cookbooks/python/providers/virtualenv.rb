#
# Cookbook Name:: python
# Resource:: virtualenv
#
# Copyright (C) 2015 Simon Dobson
#
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

require 'open-uri'

use_inline_resources


# Helper routine to work out the directory the virtualenv is in
def virtualenv_dir
  return ::File.join(node[:python][:dir], new_resource.virtualenv)
end
 
# Create a named virtualenv in a home directory, pulling requirements from the web
action :create do
  if ::File.exist?("#{virtualenv_dir}")
    Chef::Log.info "Virtualenv #{new_resource.virtualenv} already exists"
  else
    converge_by("Create Python virtualenv #{new_resource.virtualenv}") do
      create_virtualenv
      create_requirements
      install_requirements
    end
  end
end
 
# Create the virtualenv
def create_virtualenv
  bash "create_virtualenv_#{new_resource.virtualenv}" do
    cwd node[:python][:dir]
    user node[:python][:user]
    code <<-EOF
virtualenv #{new_resource.virtualenv}
EOF
  end
end

# Copy in the requirements
def create_requirements
  file "#{virtualenv_dir}/requirements.txt" do
    owner node[:python][:user]
    content open(new_resource.requirements) { |io| io.read }
  end
end

# Install requirements into the virtualenv
def install_requirements
  bash "install_virtualenv_#{new_resource.virtualenv}" do
    cwd virtualenv_dir
    user node[:python][:user]
    code <<-EOF
. bin/activate
pip install --requirement requirements.txt
EOF
  end
end
