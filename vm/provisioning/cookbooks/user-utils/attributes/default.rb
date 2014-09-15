#
# Cookbook Name:: user-utils
#
# Copyright (C) 2014 Simon Dobson <simon.dobson@computer.org>
#

# The username for the user we create
default['user-utils']['username'] = "newuser"

# The description for the user we create
default['user-utils']['description'] = "A new user"

# The group for the user we create
default['user-utils']['group'] = "users"

# The default SSH key file
default['user-utils']['ssh-public-key'] = ""

