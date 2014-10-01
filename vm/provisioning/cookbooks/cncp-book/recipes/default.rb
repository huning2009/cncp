#
# Cookbook Name:: cncp-book
# Recipe:: default
#
# Copyright (C) 2014 Simon Dobson
#

# Update the package structure
include_recipe "apt::update"

# Gnome desktop
include_recipe "gnome::desktop"

# Assorted packages that come in handy
package "locate"
package "chef"
package "curl"

# Software needed to run the notebooks
include_recipe "python-networkx::with-graphics"

# Browser
package "firefox"

# LaTeX (for PDF generation)
package "texlive"
package "texlive-latex-extra"

# Graphics handling (for PNG and SVG translation)
package "imagemagick"
package "inkscape"
package "gimp"
package "evince"

# Packages needed for the book's build system
package "git"
package "zip"
package "perl"
package "python-bs4"

# Set up user and have them auto-login
node.override['user-utils']['username'] = node['cncp-book']['username']
node.override['user-utils']['description'] = node['cncp-book']['description']
include_recipe "user-utils::user"
include_recipe "gnome::autologin"
# include_recipe "gnome::disable-screenlock"

# Install the book from the public git repo and build it
git "/home/#{node['cncp-book']['username']}/complex-networks-complex-processes" do
  repository "https://github.com/simoninireland/cncp.git"
  user node['cncp-book']['username']
end
execute "make-book" do
  cwd "/home/#{node['cncp-book']['username']}/complex-networks-complex-processes"
  user node['cncp-book']['username']
  command "make"
end

# Install a script to start up the IPython server and open a browser
# onto it (and disable screensaver lock) when the user logs-in
cookbook_file "cncp.sh" do
  path "/home/#{node['cncp-book']['username']}/cncp.sh"
  user node['cncp-book']['username']
  group "users"
  mode "755"
end

# Install a Gnome autostart desktop shortcut to run the script
%w( .config .config/autostart ).each do |path|
  directory "/home/#{node['cncp-book']['username']}/#{path}" do
    user node['cncp-book']['username']
    group "users"
    mode "755"
  end
end
template "/home/#{node['cncp-book']['username']}/.config/autostart/ipython-notebook.desktop" do
  source "ipython-notebook.erb"
  user node['cncp-book']['username']
  group "users"
  mode "755"
  variables ({
               :name => "IPython notebook server",
               :comment => "Start the IPython notebook server for the book chapters",
               :exec => "/home/#{node['cncp-book']['username']}/cncp.sh"
             })
end



