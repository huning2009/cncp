#
# Cookbook Name:: user-utils
# Recipe:: disable-screenlock
#
# Copyright (C) 2014 Simon Dobson
#

# Disable screensaver lock so we don't need a password for the user
execute "disable-screensaver" do
  command "dconf write /org/gnome/desktop/screensaver/lock-enabled false"
  user node['user-utils']['username']
end
