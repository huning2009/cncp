#
# Cookbook Name:: python
# Recipe:: python
#
# Copyright (C) 2015 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# Python
package "python"

# Build tools
package "install_python_build_tools" do
  case node[:platform]
  when 'ubuntu', 'debian'
    package_name "python-dev"
  else
    package_name "python-devel"
  end
end

