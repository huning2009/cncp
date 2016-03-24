#
# Cookbook Name:: vagrant
# Recipe:: install-boxes
#
# Copyright (C) 2015 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# Need the Ruby development tools as well (on Debian, anyway)
package 'ruby-dev'

# Download and install any requested boxes, making sure we don't have them already
# so that the recipe remains idempotent
# (Only checked against box names, not URLs.)
node['vagrant']['boxes'].each do |name, url|
  bash "install-vagrant-box-#{name}" do
    user node['vagrant']['user']
    environment ({ 'HOME' => "#{node['vagrant']['dir']}",
                   'USER' => node['vagrant']['user'] })
    code <<-EOH
if (vagrant box list | egrep -q '^#{name}'); then
   echo "Box #{name} is already installed -- skipping"
else
   vagrant box add #{name} #{url}
fi
EOH
  end
end

