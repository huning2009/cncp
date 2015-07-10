#
# Cookbook Name:: python
# Resource:: virtualenv
#
# Copyright (C) 2015 Simon Dobson
#
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# Actions
actions :create         # create and populate the virtualenv 
                        # (sd note: do we need :update too?)
default_action :create

# Attributes
attribute :virtualenv, :kind_of => String, :name_attribute => true    # name of virtualenv
attribute :requirements, :kind_of => String, :required => true        # URL of requirements.txt
attribute :user, :kind_of => String, :default => 'vagrant'            # user to install for
attribute :dir, :kind_of => String, :default => '/home/vagrant'       # directory to install into

