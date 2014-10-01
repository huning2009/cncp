# apt-get-update-cookbook

Update APT package cache, since the one installed on a base box
will typically be more or less out of date. The disadvantage of
this is that we lose explicit control over package versions, but
the advantage is that we get the latest ones.

## Supported Platforms

Ubuntu (and presumably any other Debian-derived) Linux distro.

## Attributes

None

## Usage

### apt-get-update::default

Include `apt-get-update` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[apt-get-update::default]"
  ]
}
```

## License and Authors

Author:: Simon Dobson (<simon.dobson@computer.org>)
