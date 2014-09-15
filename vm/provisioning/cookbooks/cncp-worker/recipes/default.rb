#
# Cookbook Name:: cncp-worker
# Recipe:: default
#
# Copyright (C) 2014 Simon Dobson
#

include_recipe 'apt-get-update::default'
include_recipe 'python-networkx::default'
include_recipe 'cncp::default'
