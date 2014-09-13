# python-networkx

This recipe installs Python and NetworkX in a "headless"
mode, without graphics. This enables the VM to be used
as a compute server for IPython, without the overheads
of visualisation or needing an X server.

To get this behaviour we have to compile NetworkX from
source, as its packaged forms all pull in graphical
dependencies.

