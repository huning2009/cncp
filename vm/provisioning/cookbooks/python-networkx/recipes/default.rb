# Install Python and NetworkX

# Basic Python and IPython
package 'python'
package 'ipython'

# Additional required Python packages
package 'python-numpy'
package 'python-zmq'

# Tools needed to compile NetworkX
package 'subversion'
package 'python-setuptools'

# Compile from source to avoid triggering dependencies
# for graphics packages, so we can run this VM as a
# headless compute node
script "compile-install-networkx" do
  interpreter "bash"
  code <<-EOH
  svn co https://networkx.lanl.gov/svn/networkx/trunk || (echo "Can't download networkx" ; exit 1)
  (cd trunk && sudo python setup.py install) || (echo "Error compiling networkx" ; exit 1)
  rm -fr trunk
  EOH
end

