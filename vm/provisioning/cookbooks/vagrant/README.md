# vagrant-cookbook

This cookbook installs vagrant into a VM, which then allows that VM to
create more VMs. Recursive but sometimes useful.

## Supported Platforms

Any Linux.

## Usage

### vagrant::default

Just installs vagrant, with not extra plugins.

### vagrant::azure

Installs the Microsoft Azure provider as a vagrant plugin. See
```https://github.com/MSOpenTech/Vagrant-Azure``` for details of
how the plug-in works.

## License and Authors

Author:: Simon Dobson (<simon.dobson@computer.org>)
