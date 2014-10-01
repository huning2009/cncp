#
# Cookbook Name:: python-networkx
# Recipe:: with-graphics
#
# Copyright (C) 2014 Simon Dobson
#

include_recipe "python-networkx::python"
include_recipe "python-networkx::ipython"
include_recipe "python-networkx::networkx"
include_recipe "python-networkx::mapping"
