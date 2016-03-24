#
# Cookbook Name:: vagrant
# Recipe:: install-plugins
#
# Copyright (C) 2015 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# Need the Ruby development tools as well (on Debian, anyway)
package 'ruby-dev'

# Download and install any requested plugins
node['vagrant']['plugins'].each do |plugin|
  bash "install-vagrant-plugin-#{plugin}" do
    user node['vagrant']['user']
    environment ({ 'HOME' => "#{node['vagrant']['dir']}",
                   'USER' => node['vagrant']['user'] })
    code <<-EOF
if (vagrant plugin list | egrep -q '^#{plugin}'); then
   echo "Plugin #{plugin} is already installed -- skipping"
else
   vagrant plugin install #{plugin}
fi
EOF
  end
end

