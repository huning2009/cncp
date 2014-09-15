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
  ]
}
```

## License and Authors

Author:: Simon Dobson (<simon.dobson@computer.org>)
