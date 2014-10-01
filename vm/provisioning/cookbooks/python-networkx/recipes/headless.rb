#
# Cookbook Name:: python-networkx
# Recipe:: headless
#
# Copyright (C) 2014 Simon Dobson
#

include_recipe "python-networkx::python"
include_recipe "python-networkx::ipython"
include_recipe "python-networkx::networkx-headless"
include_recipe "python-networkx::mapping"
