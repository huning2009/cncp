#
# Cookbook Name:: gnome
# Recipe:: desktop
#
# Copyright (C) 2014 Simon Dobson
#

# Minimal-ish desktop environment
gnome = %w( gnome-shell gdm gnome-panel libgnome2-bin gnome-session gnome-screensaver gnome-control-center gnome-terminal ssh-askpass-gnome )

# Install Gnome desktop
gnome.each do |p|
  package p
end

# Do we need to start any services and/or reboot to get things going?



