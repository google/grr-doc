# Contributing Documentation

GRR's documentation is stored on [GitHub](https://github.com/google/grr-doc) and is hosted on [readthedocs](https://grr-doc.readthedocs.io).

## Documentation repository structure

*master* branch of [github.com/google/grr-doc](https://github.com/google/grr-doc) contains the HEAD version of GRR documentation. Effectively, it has the documentation that will be included into the next  GRR release.

Every time a release is made, we create a new documentation branch. I.e. we have such branches as *v3.2.0*, *v3.2.1*, etc.

>**NOTE:** whenever a change in *master* branch is done, it should be applied to the latest release branch (unless the change is not backwards-compatible). Reasoning: latest release branch is what GRR users see on readthedocs.

## Contributing small documentation changes

If a suggested change doesn't include any new files, the easiest way to submit it is to edit the docs directly on GitHub. GitHub will then create a pull request for you, and then one of GRR team members can review the pull request and merge it into the master branch and latest release branch.

## Setting up editing environment with Sphinx

Readthedocs.io uses Sphinx to render the documentation. In order to have a live preview of the changes done to a local grr-doc clone, one should do the following :

```bash
mkdir ~/tmp/grr-doc
cd ~/tmp/grr-doc

virtualenv .
source bin/activate

pip install Sphinx sphinx-autobuild recommonmark sphinx_rtd_theme

git clone https://github.com/google/grr-doc
sphinx-autobuild grr-doc out
```

The code above should start the Sphinx documentation server at http://127.0.0.1:8000/. The server will monitor documentation file for changes and update instantly.

## Using Visual Studio Code as an editing tool

GRR documentation should be written in Markdown, so you can write it using any text editor you prefer. However, Visual Studio Code has a builtin support for Markdown and makes editing it really easy: you have a preview window in a separate pane that is updated as you type.

To give VSCode a try, do the following:
1. Download and install it from [https://code.visualstudio.com/download](https://code.visualstudio.com/download).
1. Launch VSCode. Click on File->Open Folder. Point the dialog to checked-out grr-doc sources.
1. Click on any of the Markdown files. Then press Ctrl-K V (this means press Ctrl + K, then separately, after Ctrl + K is not pressed anymore, press V).
1. Now if you edit the Markdown file the preview pane is going to be updated automatically.
