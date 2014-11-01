#
# Cookbook Name:: python
# Recipe:: default
#
# Copyright (C) 2014 Simon Dobson
#

include_recipe "python::python"
include_recipe "python::ipython"
include_recipe "python::graphics"
include_recipe "python::scipy"
include_recipe "python::pydata"
include_recipe "python::geo"
include_recipe "python::networkx"
