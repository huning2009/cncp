#
# Cookbook Name:: cncp-book
# Recipe:: default
#
# Copyright (C) 2015 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# ----- Configuration -----

# User, home directory, book sources
# (Easier to maintain them here than as attributes)
cncp_user = "vagrant"
cncp_user_home = "/home/#{cncp_user}"
cncp_repository = "https://github.com/simoninireland/cncp.git"
cncp_checkout = "#{cncp_user_home}/complex-networks-complex-processes"


# ----- Basics -----

# Update the package structure
include_recipe "apt::update"

# Gnome desktop
include_recipe "gnome::desktop"

# Assorted packages that come in handy
package "locate"
package "curl"


# ----- Python and necessary packages -----

# Global Python and virtualenv support
include_recipe "python::python"
include_recipe "python::virtualenv"

# Generally a good idea
package "pkg-config"

# Install libncurses development package (needed for IPython: see
# https://stackoverflow.com/questions/22892482/error-installing-gnureadline-via-pip)
package "libncurses5-dev"

# Fortran, BLAS, and LAPACK, needed for scipy to build reliably
package "gfortran"
package "libblas-dev"
package "liblapack-dev"

# Graphics stuff for matplotlib
package "libfreetype6-dev"
package "libpng12-dev"

# We don't need to install a virtualenv as the build system does it itself
# now we've set the scene with the essential packages


# ----- User interface and book build system -----

# Browser
package "firefox"

# LaTeX (for PDF generation). The extras are big (and slow to install)
package "texlive"
#package "texlive-latex-extra" do
#  timeout 1000
#end

# Graphics handling (for PNG and SVG translation)
package "imagemagick"
package "inkscape"
package "gimp"
package "evince"

# Packages needed for the book's build system
package "git"
package "zip"
package "perl"

# Un-comment and edit the following to install plugins to provision cloud-based VMs,
# which will involve some combination of plugins and base boxes
package "libz-dev"                                    # needed to buld Azure plugin
node.override['vagrant']['user'] = cncp_user
node.override['vagrant']['dir'] = cncp_user_home
node.override['vagrant']['plugins'] = %w( vagrant-azure vagrant-aws )
node.override['vagrant']['boxes'] =
  ({
     'azure' => 'https://github.com/msopentech/vagrant-azure/raw/master/dummy.box',
     'aws'   => 'https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box'
   })
include_recipe "vagrant::vagrant"

# Have the user autologin so we don't need a password
node.override['gnome']['autologin'] = cncp_user
include_recipe "gnome::autologin"

# Install a script to start up the IPython server and open a browser
# onto it (and disable screensaver lock) when the user logs-in
cookbook_file "cncp.sh" do
  path "#{cncp_user_home}/cncp.sh"
  owner cncp_user
  group "users"
  mode "755"
end

# Install a Gnome autostart desktop shortcut to run the start-up script
%w( .config .config/autostart ).each do |path|
  directory "#{cncp_user_home}/#{path}" do
    owner cncp_user
    group "users"
    mode "755"
  end
end
template "#{cncp_user_home}/.config/autostart/ipython-notebook.desktop" do
  source "ipython-notebook.erb"
  owner cncp_user
  group "users"
  mode "755"
  variables ({
               :name => "IPython notebook server",
               :comment => "Start the IPython notebook server for the book chapters",
               :exec => "#{cncp_user_home}/cncp.sh"
             })
end


# ----- The book -----

# Install the book from the public git repo
if not ::File.exist?(cncp_checkout)
  git cncp_checkout do
    user cncp_user
    repository cncp_repository
  end
end

# Build the web version of the book in the known-good virtualenv
bash "make-book" do
  user cncp_user
  cwd cncp_checkout
  code "make www"
end

