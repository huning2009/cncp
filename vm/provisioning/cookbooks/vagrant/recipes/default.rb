#
# Cookbook Name:: vagrant
# Recipe:: default
#
# Copyright (C) 2014 Simon Dobson
#

include_recipe "vagrant::vagrant"

# Install any requested plugins first
if node['vagrant']['plugins'].any?
  include_recipe "vagrant::install-plugins"
end

# ...then any requested base boxes
if node['vagrant']['boxes'].any?
  include_recipe "vagrant::install-boxes"
end

