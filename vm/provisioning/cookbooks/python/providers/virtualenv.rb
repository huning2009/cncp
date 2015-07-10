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

# Create a named virtualenv in a home directory, pulling requirements from the web
action :create do
  if ::File.exist?("#{new_resource.dir}/#{new_resource.virtualenv}")
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
  bash "create-virtualenv-#{new_resource.virtualenv}" do
    cwd new_resource.dir
    user new_resource.user
    code <<-EOF
virtualenv #{new_resource.virtualenv}
EOF
  end
end

# Copy in the requirements
def create_requirements
  file "#{new_resource.dir}/#{new_resource.virtualenv}/requirements.txt" do
    owner new_resource.user
    content open(new_resource.requirements) { |io| io.read }
  end
end

# Install requirements into the virtualenv
def install_requirements
  bash "install-virtualenv-#{new_resource.virtualenv}" do
    cwd "#{new_resource.dir}/#{new_resource.virtualenv}"
    user new_resource.user
    code <<-EOF
. bin/activate
pip install --requirement requirements.txt
EOF
  end
end
