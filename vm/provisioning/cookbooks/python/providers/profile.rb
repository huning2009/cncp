#
# Cookbook Name:: python
# Resource:: profile
#
# Copyright (C) 2016 Simon Dobson
#
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

require 'socket'

use_inline_resources

# Helper routine to work out the directory that holds all the IPython files
def ipython_dir
  return ::File.join(node[:python][:dir], ".ipython")
end

# Helper routine to work out the directory the profile is in
def profile_dir
  return ::File.join(ipython_dir, "profile_#{new_resource.profile}")
end

# Create a named IPython profile
action :create do
  if ::File.exist?(profile_dir)
    Chef::Log.info "IPython profile #{new_resource.profile} already exists"
  else
    converge_by("Create IPython profile #{new_resource.profile}") do
      create_profile
      if new_resource.parallel
        populate_profile
      end
    end
  end
end

# Create the profile
def create_profile
  # if the parallel resource has been provided, build a profile
  # suitable for parallel computation
  if new_resource.parallel
    parallel = "--parallel"
  else
    parallel = ""
  end
  
  # if we're running from a virtualenv, make the code needed to do so assuming
  # we'll be in the directory that contains it already
  if new_resource.virtualenv
    ve = ". #{::File.join(new_resource.virtualenv, 'bin/activate')}"
  else
    ve = ""
  end

  # create the profile
  bash "create_ipython_profile_#{new_resource.profile}" do
    user node[:python][:user]
    cwd node[:python][:dir]
    code <<-EOF
#{ve}
ipython profile create #{new_resource.profile} #{parallel} --ipython-dir=#{ipython_dir}
EOF
  end
end


# Populate the profile with connection information
def populate_profile
  # if there's no external name specified for the controller, use the hostname
  if new_resource.ssh_server
    external = new_resource.ssh_server
  else
    external = ::Socket.gethostname
    Chef::Log.info "No hostname given, using #{external} "
  end

  # if there's no internal name specified for the controller, use the external name
  if new_resource.internal_ssh_server
    internal = new_resource.internal_ssh_server
  else
    internal = external
  end
  
  # populate the configuration file at the end  
  bash "populate_ipython_profile_#{new_resource.profile}" do
    cwd profile_dir
    user node[:python][:user]
    code <<-EOF
cat >>ipcontroller_config.py <<EOC

# ----- begin added automatically by chef -----

# logging
c.IPControllerApp.log_to_file = True
c.IPControllerApp.clean_logs = True

# ssh connections
c.IPControllerApp.ssh_server = "#{external}"
c.IPControllerApp.reuse_files = True
c.HubFactory.ip = u'*'
c.IPControllerApp.location = "#{internal}"

# ----- end added automatically by chef -----
EOC
EOF
    end
end


