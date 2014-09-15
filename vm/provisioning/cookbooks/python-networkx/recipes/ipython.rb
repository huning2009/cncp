#
# Cookbook Name:: python-networkx
# Recipe:: ipython
#
# Copyright (C) 2014 Simon Dobson
#

# Package needed to build IPython
package "python-pip"
package "python-setuptools"

# Install IPython using pipm as the versions in the
# distro repos are often out of date
script "install-ipython" do
  interpreter "bash"
  code <<-EOH
  pip install --upgrade ipython || (echo "Failed to install latest IPython" ; exit 1)
  EOH
end

