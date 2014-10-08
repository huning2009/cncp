#!/usr/bin/env bash

# Disable screensaver lock as we don't have a password
dconf write /org/gnome/desktop/screensaver/lock-enabled false

# Run the IPython notebook server and open a browser
(cd complex-networks-complex-processes && nohup ipython notebook &)

# Open the contents page in a tab
sleep 2
gnome-open http://localhost:8888/notebooks/complex-networks-complex-processes.ipynb &
