#
# Cookbook Name:: vagrant
# Recipe:: install-boxes
#
# Copyright (C) 2014 Simon Dobson
#

# Install vagrant
package "vagrant"

# Need the Ruby development tools as well (on Debian, anyway)
package 'ruby-dev'

# Download and install any requested boxes
node['vagrant']['boxes'].each do |name, url|
  execute "install-vagrant-box-#{name}" do
    user node['vagrant']['username']
    command "vagrant box add #{name} #{url}"
    environment ({ 'HOME' => "/home/#{node['vagrant']['username']}",
                   'USER' => node['vagrant']['username'] })
  end
end

