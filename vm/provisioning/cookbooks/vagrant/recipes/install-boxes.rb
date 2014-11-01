#
# Cookbook Name:: vagrant
# Recipe:: install-boxes
#
# Copyright (C) 2014 Simon Dobson
#

include_recipe "vagrant::vagrant"

# Need the Ruby development tools as well (on Debian, anyway)
package 'ruby-dev'

# Download and install any requested boxes, making sure we don't have them already
# so that the recipe remains idempotent
# (Only checked against box names, not URLs.)
node['vagrant']['boxes'].each do |name, url|
  script "install-vagrant-box-#{name}" do
    user node['vagrant']['username']
    interpreter "bash"
    environment ({ 'HOME' => "/home/#{node['vagrant']['username']}",
                   'USER' => node['vagrant']['username'] })
    code <<-EOH
if (vagrant box list | egrep -q '^#{name}'); then
   echo "Box #{name} is already installed -- skipping"
else
   vagrant box add #{name} #{url}
fi
EOH
  end
end

