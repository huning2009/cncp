#
# Cookbook Name:: cncp
# Recipe:: default
#
# Copyright (C) 2014 Simon Dobson <simon.dobson@computer.org>
#

# Override attributes for user-utils recipes
node.override['user-utils']['username'] = node['cncp']['username']
node.override['user-utils']['description'] = node['cncp']['description']
node.override['user-utils']['ssh-public-key'] = node['cncp']['ssh-public-key']

# Create network science worker user and home directory
include_recipe 'user-utils::user'

# Install SSH keys
include_recipe "user-utils::ssh"

# Install welcome message
cookbook_file "motd" do
  path "/etc/motd"
  owner "root"
  group "root"
  mode "644"
end


