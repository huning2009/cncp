#
# Cookbook Name:: python
# Recipe:: graphics
#
# Copyright (C) 2014 Simon Dobson
#

include_recipe "python::python"

# matplotlib, the main Python graphical tool
package "python-matplotlib"

# seaborn, a more friendly graphical system built on matplotlib
script "install-ipython" do
  interpreter "bash"
  code <<-EOH
  pip install --upgrade seaborn || (echo "Failed to install seaborn" ; exit 1)
  EOH
end




