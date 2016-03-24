#
# Cookbook Name:: vagrant
# Recipe:: vagrant
#
# Copyright (C) 2015 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# Install vagrant
package "vagrant"


# Install any requested plugins first
if node['vagrant']['plugins'].any?
  include_recipe "vagrant::install-plugins"
end

# ...then any requested base boxes
if node['vagrant']['boxes'].any?
  include_recipe "vagrant::install-boxes"
end

