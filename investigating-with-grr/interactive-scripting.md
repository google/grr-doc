# Interactive scripting

GRR Colab is an alternative GRR API that allows you to work with GRR 
interactively. It is represented as IPython extension and can be used with 
[IPython][ipython] itself, [Jupyter][jupyter] or [Colaboratory][colab].

## Extension API

The GRR Colab offers two APIs.

*Python API* allows to work with multiple clients simultaneously since each 
client is represented as a usual Python object. All functions return Protobuf 
objects for non-trivial values. In order to start a flow you just call a single 
method. Python API does not have a state so you have to always specify absolute 
paths.

*Magic API* has a state and that's why it allows to work with a single client 
only since you have to select a client first. The magic commands have Bash-like 
syntax and return Pandas dataframes for non-trivial values. The state allows 
you to work with relative paths also.

More details about both APIs you can find [here][jupyter-notebook] in the
Jupyter notebook demo.

## Enabling GRR IPython extension

First, install `grr-colab` Python package. On successful installation you 
should be able to import `grr_colab` from Python (or IPython) terminal. Python 
API should be already available for you.

In order to enable Magic API `grr_colab.ipython_extension` must be loaded. You 
may do this in two ways:

* If you want the extension to be loaded on the IPython kernel start, open 
IPython config file and add `grr_colab.ipython_extension` to 
`c.InteractiveShellApp.extensions` list. Then Magic API should be available 
right after creating new Jupyter notebook or starting new IPython session.

* If you want to enable the extension for the current session only, run 
`%load_ext grr_colab.ipython_extension` command in you Jupyter notebook or 
IPython terminal.

[jupyter]: https://jupyter.org/
[ipython]: https://ipython.org/
[colab]: https://colab.research.google.com/
[jupyter-notebook]: https://nbviewer.jupyter.org/github/google/grr/blob/master/colab/examples/demo.ipynb
