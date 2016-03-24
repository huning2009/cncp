#
# Cookbook Name:: gnome
# Recipe:: desktop
#
# Copyright (C) 2015 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# Install Gnome desktop packages
node['gnome']['desktop'].each do |p|
  package p
end

# Do we need to start any services and/or reboot to get things going?



