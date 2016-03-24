#
# Cookbook Name:: gnome
# Recipe:: autologin
#
# Copyright (C) 2015 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# Make sure we have awk for doing the file editing
package "gawk"

# Create an awk script to edit the GDM custom configuration and
# add an auto-login for the user we're creating
file "#{Chef::Config[:file_cache_path]}/autologin.awk" do
  owner 'root'
  mode '744'
  content <<-EOF
/# +AutomaticLoginEnable.*/  { print "AutomaticLoginEnable = true";
                               next; }
/# +AutomaticLogin.*/        { printf "AutomaticLogin = "; print u;
                               next; }
                             { print $0; }
EOF
end

# Take a copy of the /etc/gdm/custom.conf before editing it
execute "backup-custom.conf" do
  command "cp /etc/gdm/custom.conf /etc/gdm/custom.conf.orig" 
  not_if { ::File.exists?("/etc/gdm/custom.conf.orig") }
end

# Apply the awk script to the /etc/gdm/custom.conf configuration file
bash "make-autologin" do
  code <<-EOF
cd #{Chef::Config[:file_cache_path]}
cp /etc/gdm/custom.conf .
awk -f autologin.awk u=#{node['gnome']['autologin']} <custom.conf >/etc/gdm/custom.conf
EOF
end

