# user-utils-cookbook

A collection of utility recipes for setting up users and
associated directories and files.

## Supported Platforms

Ubuntu Linux, and probably all other Linuxen.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['user-utils']['username']</tt></td>
    <td>String</td>
    <td>Username for new user</td>
    <td><tt>"newuser"</tt></td>
  </tr>
  <tr>
    <td><tt>['user-utils']['description']</tt></td>
    <td>String</td>
    <td>Description of new user</td>
    <td><tt>"users"</tt></td>
  </tr>
  <tr>
    <td><tt>['user-utils']['group']</tt></td>
    <td>String</td>
    <td>Group name for new user</td>
    <td><tt>"A new user"</tt></td>
  </tr>
  <tr>
    <td><tt>['user-utils']['ssh-public-key']</tt></td>
    <td>String</td>
    <td>SSH public key string for new user</td>
    <td><tt>none</tt></td>
  </tr>
</table>

## Usage

### user-utils::default

Default tasks creates a user. Equivalent to:

Include `user-utils` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[user-utils::user]"
  ]
}
```

### user-utils::user

Creates a user and their home directory.

### user-utils::ssh

Installs ssh keys for the user. This allows password-less login.

## License and Authors

Author:: Simon Dobson (<simon.dobson@computer.org>)
