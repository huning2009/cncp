# gnome-cookbook

Install Gnome desktop and perform various useful management
functions.

## Supported Platforms

Anything that runs X and Gome.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['gnome']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### gnome::default

Include `gnome` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[gnome::default]"
  ]
}
```

## License and Authors

Author:: Simon Dobson <simon.dobson@computer.org>
