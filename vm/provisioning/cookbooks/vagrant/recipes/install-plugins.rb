#
# Cookbook Name:: vagrant
# Recipe:: install-plugins
#
# Copyright (C) 2014 Simon Dobson
#

# Install vagrant
package "vagrant"

# Need the Ruby development tools as well (on Debian, anyway)
package 'ruby-dev'

# Download and install any requested plugins
node['vagrant']['plugins'].each do |plugin|
  execute "install-vagrant-plugin-#{plugin}" do
    user node['vagrant']['username']
    command "vagrant plugin install #{plugin}"
    environment ({ 'HOME' => "/home/#{node['vagrant']['username']}",
                   'USER' => node['vagrant']['username'] })
  end
end

