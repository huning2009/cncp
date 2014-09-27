# python-networkx-cookbook

Install NetworkX, a Python library for network science.

The default installs NetworkX in "headless" mode that
doesn't pull in the graohical dependencies, allowing
the resulting VM to run headless and be used solely as
a compute server.

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
    <td><tt>['python-networkx']['networkx-url']</tt></td>
    <td>String</td>
    <td>URL to the svn NetworkX software distribution</td>
    <td><tt>"https://networkx.lanl.gov/svn/networkx/trunk"</tt></td>
  </tr>
</table>

## Usage

### python-networkx::default

Install NetworkX headless. Equivalent to:

```json
{
  "run_list": [
    "recipe[python-networkx::python]",
    "recipe[python-networkx::ipython]",
    "recipe[python-networkx::headless]"
    "recipe[python-networkx::mapping]"
  ]
}
```

### python-networkx::python

Install Python and some essential packages like ```numpy```.

### python-networkx::ipython

Install IPython from sources. This is necessay because the
version of IPython in the typical repos is out of date wit
respect to the main tree -- and we need a recent version.

### python-networkx::headless

Install ```NetworkX```, again from sources. This time it's to
get the katest version, but also because we want to run the VM
headless (without any display), and a packaged version would
pull in the graphics dependencies. 

### python-networkx::mapping

Install some additional packages used for geographical data
and mapping.

## License and Authors

Author:: Simon Dobson (<simon.dobson@computer.org>)
