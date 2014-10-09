#
# Cookbook Name:: vagrant
#
# Copyright (C) 2014 Simon Dobson
#

# User who will be running vagrant
default['vagrant']['username'] = 'newuser'

# List of plugins to install (defaults to none)
default['vagrant']['plugins'] = %w( )

# List of boxes to install (defaults to none)
default['vagrant']['boxes'] = ({ })

