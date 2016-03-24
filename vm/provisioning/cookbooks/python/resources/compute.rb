#
# Cookbook Name:: python
# Resource:: compute
#
# Copyright (C) 2016 Simon Dobson
#
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# Actions
actions :create         # create compute servers 
default_action :create

# Attributes
attribute :virtualenv, :kind_of => [ String, FalseClass ], :default => false    # name of virtualenv
attribute :profile, :kind_of => [ String, FalseClass ], :default => false       # name of IPython profile
attribute :engines, :kind_of => [ Integer, FalseClass ], :default => false      # number of engines to start

