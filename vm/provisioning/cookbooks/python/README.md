# python-cookbook

Install Python, its scientfic, graphical, interactive,
and data-driven extensions.

Pythin is the *lingua franca* of scientific computing.
These recipes various Python libraries and tools in
various configurations.

## Supported Platforms

Unbuntu, and any other Linuxen.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['python']['networkx-url']</tt></td>
    <td>String</td>
    <td>URL to the svn NetworkX software distribution</td>
    <td><tt>"https://networkx.lanl.gov/svn/networkx/trunk"</tt></td>
  </tr>
</table>

## Usage

### python::default

Install a rather complete Python suite, including IPython, scientific,
data, graphical, and network extensions.


### python::python

Install Python.

### python::graphics

Install various graphical tools for Python.

### python::scipy

Install the Scientific Python stack.

### python::pydata

Install the Python data-driven stack.

### python::ipython

Install IPython from sources. This is necessay because the
version of IPython in the typical repos is out of date wit
respect to the main tree -- and we need a recent version.

This recipe installs a rather complete package for IPython,
including all the packages needed to support the notebook
server and the parallel processing extensions. These should
perhaps be optional, or seperated into another recipe.

### python::networkx-headless

Install ```NetworkX```, again from sources. This time it's to
get the katest version, but also because we want to run the VM
headless (without any display), and a packaged version would
pull in the graphics dependencies. 

### python::networkx

Install ```NetworkX```, the Pythin network science package.
This will draw in load of graphical dependencies: use
```python::networkx-headless``` for just computing.

### python::geo

Install some additional packages used for geographical data
and mapping.

## License and Authors

Author:: Simon Dobson (<simon.dobson@computer.org>)
