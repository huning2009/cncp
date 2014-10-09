# vagrant-cookbook

This cookbook installs vagrant into a VM, which then allows that VM to
create more VMs. Recursive but sometimes useful.

## Supported Platforms

Any Linux.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['vagrant']['plugins']</tt></td>
    <td>list of String</td>
    <td>vagrant plugins to install</td>
    <td>none</td>
  </tr>
  <tr>
    <td><tt>['vagrant']['boxes']</tt></td>
    <td>hash of String to URL (String)</td>
    <td>vagrant base boxes to install</td>
    <td>none</td>
  </tr>
</table>

## Usage

### vagrant::default

Install vagrant and any plugins and base boxes listed in the
attributes. This is the only recipe that needs to be called
directly: it will use the sub-recipes as required. 

### vagrant::install-plugins

Install any extra plugins. These should be listed in the ```plugins```
attribute as strings, for example ```vagrant-aws```.

### vagrant::install-boxes

Install any base boxes. These should be listed in the ```boxes```
hash as name/url pairs, for example ```'aws' => 'https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box'```.

## License and Authors

Author:: Simon Dobson (<simon.dobson@computer.org>)
