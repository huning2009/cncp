# python-cookbook

Install Python and virtual environments. Python is the *lingua franca* of
scientific computing.

We provide for global Python installation and for the creation and
population of virtual enviromments ("virtualenvs") that isolate a set
of Python packages.


## Supported Platforms

Tested on Ubuntu, should work on any Linux,


## Attributes

None


## Recipes

### python::python

A basic global Python installation with development tools, which are typically
needed fror anything more complicated. (These might be better separated, but they're
so common it seems silly not to take them by default.)

### python::virtualenv

Install the virtual environment ("virtualenv") tools, used to create isolated
environments with known configurations. These can be populated using requirements.txt
files specifying the package versions needed (see the ```python_virtualenv``` resource).


## Resources

### python_virtualenv

Create and populate a virtualenv. This resource has the following attributes:

* ```virtualenv```: the name of the virtualenv to create
* ```requirements```: URL of the requirmenets.txt file describing the packages
* ```user```: user to install the virtualenv for (defaults to "vagrant")
* ```dir```: directory to place the virtualenv in (defaults to "/home/vagrant") 

For example:

```
python_virtualenv "test" do
  virtualenv "test"     # defaults to the resource name
  user "test"
  dir "/home/test"
  requirements "http://www.test.com/requirements.txt"
end
'''


## License and Authors

Author:: Simon Dobson (<simon.dobson@computer.org>)

License:: Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License
          (https://creativecommons.org/licenses/by-nc-sa/3.0/).
