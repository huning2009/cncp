#
# Cookbook Name:: user-utils
# Recipe:: ssh
#
# Copyright (C) 2014 Simon Dobson <simon.dobson@computer.org>
#

# Install SSH key into ~/.ssh
directory "/home/#{node['user-utils']['username']}/.ssh" do
  owner node['user-utils']['username']
  group node['user-utils']['group']
  mode "700"
end
file "authorized_keys" do
  path "/home/#{node['user-utils']['username']}/.ssh/authorized_keys"
  content node['user-utils']['ssh-public-key']
  owner node['user-utils']['username']
  group node['user-utils']['group']
  mode "600"
end


