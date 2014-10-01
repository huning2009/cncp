#
# Cookbook Name:: user-utils
# Recipe:: autologin
#
# Copyright (C) 2014 Simon Dobson
#

# Make sure we have awk for doing the file editing
package "gawk"

# Create an awk script to edit the GDM custom configuration and
# add an auto-login for the user we're creating
file "#{Chef::Config[:file_cache_path]}/autologin.awk" do
  owner 'root'
  mode '744'
  content <<-EOH
/# +AutomaticLoginEnable.*/  { print "AutomaticLoginEnable = true";
                               next; }
/# +AutomaticLogin.*/        { printf "AutomaticLogin = "; print u;
                               next; }
                             { print $0; }
EOH
end

# Take a copy of the /etc/gdm/custom.conf before editing it
execute "backup-custom.conf" do
  command "cp /etc/gdm/custom.conf /etc/gdm/custom.conf.orig" 
  not_if { ::File.exists?("/etc/gdm/custom.conf.orig") }
end

# Apply the awk script to the /etc/gdm/custom.conf configuration file
script "make-autologin" do
  interpreter "bash"
  code <<-EOH
  cd #{Chef::Config[:file_cache_path]}
  cp /etc/gdm/custom.conf .
  awk -f autologin.awk u=#{node['user-utils']['username']} <custom.conf >/etc/gdm/custom.conf
  EOH
end

