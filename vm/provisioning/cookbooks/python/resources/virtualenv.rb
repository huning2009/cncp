#
# Cookbook Name:: python
# Resource:: virtualenv
#
# Copyright (C) 2016 Simon Dobson
#
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# Actions
actions :create         # Create a new virtualenv
default_action :create

# Attributes
attribute :virtualenv, :kind_of => [ String, FalseClass ], :name_attribute => true    # name of virtualenv
attribute :requirements, :kind_of => String, :required => true                        # requirements.txt URI or filename


