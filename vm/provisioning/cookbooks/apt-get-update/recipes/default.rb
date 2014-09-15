#
# Cookbook Name:: apt-get-update
# Recipe:: default
#
# Copyright (C) 2014 Simon Dobson
#

script "apt-get-update" do
  interpreter "bash"
  code <<-EOH
  sudo apt-get update || echo "Couldn't update package tree -- continuing"
  EOH
end
