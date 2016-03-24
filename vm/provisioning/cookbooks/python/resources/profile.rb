#
# Cookbook Name:: python
# Resource:: profile
#
# Copyright (C) 2016 Simon Dobson
#
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# Actions
actions :create         # create the profile 
default_action :create

# Profile attributes
attribute :profile, :kind_of => String, :name_attribute => true    # name of profile
attribute :parallel, :kind_of => [ TrueClass, FalseClass ], :default => false  
                                                                   # parallel computing
attribute :ssh_server, :kind_of => [ String, FalseClass ], :default => false
                                                                   # name of ssh server to access controller,
                                                                   # defaults to VM's hostname
attribute :internal_ssh_server, :kind_of => [ String, FalseClass ], :default => false
                                                                   # name of ssh server as seen by engines,
                                                                   # defaults to external name

# Virtualenv attributes
attribute :virtualenv, :kind_of => [ String, FalseClass ], :default => false       
                                                                   # name of virtualenv to run from

