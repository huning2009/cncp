#
# Cookbook Name:: cncp-compute
#
# Copyright (C) 2016 Simon Dobson <simon.dobson@computer.org>
#
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# User details
default[:cncp][:user] = "vagrant"
default[:cncp][:dir] = "/home/vagrant"

# Python virtual environment name
default[:cncp][:virtualenv] = "cncp-compute"

# Python profile attributes
default[:cncp][:profile] = "cncp"
#default[:cncp][:ssh_server] =

# Python requirements URI
default[:cncp][:requirements] =  "https://raw.githubusercontent.com/simoninireland/cncp/master/cncp-compute-requirements.txt"
