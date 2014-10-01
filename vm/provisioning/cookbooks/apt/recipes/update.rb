#
# Cookbook Name:: apt
# Recipe:: update
#
# Copyright (C) 2014 Simon Dobson
#

# Update the apt package structure
execute "apt-get-update" do
  command 'apt-get update || echo "Couldn\'t update package tree -- continuing"'
  user "root"
end
