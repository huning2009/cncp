#
# Cookbook Name:: python-networkx
# Recipe:: headless
#
# Copyright (C) 2014 Simon Dobson
#

# Package needed to build NetworkX
package "subversion"

# Compile NetworkX from source to avoid triggering dependencies
# for graphics packages, so we can run this VM as a headless
# compute node
ENV['URL'] = node['python']['networkx-url']
script "compile-install-networkx" do
  interpreter "bash"
  code <<-EOH
  svn co $URL || (echo "Can't download NetworkX" ; exit 1)
  (cd trunk && sudo python setup.py install) || (echo "Error compiling networkx" ; exit 1)
  rm -fr trunk
  EOH
end

