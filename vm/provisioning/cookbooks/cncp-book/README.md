# cncp-book-cookbook

Cookbook for building the VM needed to build "Complex networks,
complex processes". This installs the necessary tools and then
installs the sources for the book from the git repo. Slightly
recursively, this will also install this cookbook.

## Supported Platforms

Any Linux or other Unix.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cncp-book']['source-git']</tt></td>
    <td>String</td>
    <td>git repository for book sources</td>
    <td>the master repo</td>
  </tr>
</table>

## Usage

### cncp-book::default

Include `cncp-book` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cncp-book::default]"
  ]
}
```

## License and Authors

Author:: Simon Dobson (<simon.dobson@computer.org>)
