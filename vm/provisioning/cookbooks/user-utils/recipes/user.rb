#
# Cookbook Name:: user-utils
# Recipe:: user
#
# Copyright (C) 2014 Simon Dobson
#

# Create new user
user node['user-utils']['username'] do
  comment node['user-utils']['description']
  username node['user-utils']['username']
  gid "users"
  home "/home/" + node['user-utils']['username']
  shell "/bin/bash"
  supports :manage_home => true
end

# Lock-down user's home directory
directory "/home/" + node['user-utils']['username'] do
  mode "0755"
end

