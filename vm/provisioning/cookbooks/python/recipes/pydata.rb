#
# Cookbook Name:: python
# Recipe:: pydata
#
# Copyright (C) 2014 Simon Dobson
#

include_recipe "python::python"
include_recipe "python::scipy"

# Symbolic maths
package "python-sympy"




