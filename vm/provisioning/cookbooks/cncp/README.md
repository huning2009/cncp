# cncp-cookbook

A cookbook to set up the user for the "Complex networks, complex
processes" VM.

## Supported Platforms

Ubuntu Linux. Probably other Linuxen too.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cncp']['username']</tt></td>
    <td>String</td>
    <td>Default name for user</td>
    <td><tt>"cncp"</tt></td>
  </tr>
  <tr>
    <td><tt>['cncp']['group']</tt></td>
    <td>String</td>
    <td>Default description for user</td>
    <td><tt>"users"</tt></td>
  </tr>
  <tr>
    <td><tt>['cncp']['ssh-public-key']</tt></td>
    <td>String</td>
    <td>SSH public key for user</td>
    <td><tt>"none"</tt></td
  </tr>
</table>

## Usage

### cncp::default

Include `cncp` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cncp::default]"
  ]
}
```

## License and Authors

Author:: Simon Dobson (simon.dobson@computer.org)
