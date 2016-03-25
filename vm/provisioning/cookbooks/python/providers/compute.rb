#
# Cookbook Name:: python
# Resource:: compute
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

# Helper routine to work out the directory the virtualenv is in
def virtualenv_dir
  return ::File.join(node[:python][:dir], new_resource.virtualenv)
end

# Create compute engines
action :create do
  converge_by("Start IPython compute engines") do
    stop_compute_engines
    start_compute_engines
  end
end

# Stop any engines that are running, in case we're re-provisioning
def stop_compute_engines
  pidfile=::File.join(profile_dir, "pid", "ipcontroller.pid")
  if ::File.exists?(pidfile)
    Chef::Log.info "Stopping running controllers"
    bash "stop_compute_engines" do
      user node[:python][:user]
      code <<-EOF
kill -15 `cat #{pidfile}`
rm #{pidfile}
EOF
    end
  end
end

# Start compute engines
def start_compute_engines
  pidfile=::File.join(profile_dir, "pid", "ipcontroller.pid")
  if new_resource.engines
    engines = "#{new_resource.engines}"
  else
    engines = ""
  end

  bash "start_compute_engines" do
    cwd virtualenv_dir
    user node[:python][:user]
    creates pidfile
    code <<-EOF
. bin/activate

nohup ipcontroller --profile=#{new_resource.profile} --ipython-dir=#{ipython_dir} &

REQCORES="#{engines}"
CORES=${REQCORES:-`grep -c processor /proc/cpuinfo`}
for i in $(seq 1 $CORES); do
  nohup ipengine --profile=#{new_resource.profile} --ipython-dir=#{ipython_dir} &
done
EOF
  end
end


