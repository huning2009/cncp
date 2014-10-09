#
# Cookbook Name:: vagrant
# Recipe:: default
#
# Copyright (C) 2014 Simon Dobson
#

# Install vagrant
package "vagrant"

# Install any requested plugins
if node['vagrant']['plugins'].any?
  include_recipe "vagrant::install-plugins"
end

# Install any requested boxes
if node['vagrant']['boxes'].any?
  include_recipe "vagrant::install-boxes"
end

