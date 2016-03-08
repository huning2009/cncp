# cncp-compute-cookbook

This cookbook provides recipes that wrap all the cookbooks
required by the "Complex networks, complex processes" compute
servers. This sets up the libraries and tools needed to perform
network science simulations, without any graphical capabilities.

There are two main recipes, specialised for building virtual machines,
or for provisioning a user directory on a physical machine. 


## Supported Platforms

Tested for Ubuntu (VM) and Scientific Linux (physical), but should
work on any Linux. May need work on variant names of packages on
different platforms.


## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cncp-computer']['username']</tt></td>
    <td>String</td>
    <td>username of compute server user</td>
    <td><tt>vagrant</tt></td>
  </tr>
  <tr>
    <td><tt>['cncp-computer']['home']</tt></td>
    <td>String</td>
    <td>home directory for user</td>
    <td><tt>/home/<i>username</i></tt></td>
  </tr>
  <tr>
    <td><tt>['cncp-computer']['virtualenv']</tt></td>
    <td>String</td>
    <td>name of the Python virtual envronment to create</td>
    <td><tt>cncp-compute</tt></td>
  </tr>
  <tr>
    <td><tt>['cncp-computer']['requirements-uri']</tt></td>
    <td>String (URL)</td>
    <td>URI of Python requirements file</td>
    <td>from the book repository</td>
  </tr>
</table>


## Usage

Run the cncp-worker::vm (or cncp-worked::default) recipe to build
a compute server VM. Run the cncp-worker::barematal recipe for a
physical machine.


## License and Authors

Author:: Simon Dobson (<simon.dobson@computer.org>)

License:: Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License
          (https://creativecommons.org/licenses/by-nc-sa/3.0/).
