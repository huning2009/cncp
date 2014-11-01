#
# Cookbook Name:: python
# Recipe:: scipy
#
# Copyright (C) 2014 Simon Dobson
#

include_recipe "python::python"

# Maths packages
package "python-numpy"

# Pandas for data analysis
package "python-pandas"

# Machine learning
package "python-scikit-learn"


