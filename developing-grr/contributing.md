# Contributing Code

GRR is a somewhat complex piece of code. While this complexity is
necessary to provide the scale and performance characteristics we need,
it makes it more difficult to get involved and understand the code base.
So just be aware that making significant changes in the core will be
difficult if you don’t have a software engineering background, or solid
experience with python that includes use of things like pdb and
profiling.

That said, we want your contribution\! You don’t need to be a veteran
pythonista to contribute artifacts or parsers. But whatever your
experience, we strongly recommend starting somewhere simple before
embarking on core changes and reading our documentation. In particular
we recommend these as good starting points:

  - Build a standalone console script to perform the actions you want. A
    standalone console script won’t benefit from being able to be run as
    a Collector or a Hunt, but it will get you familiar with the API,
    and an experienced developer can convert it into a fully fledged
    flow afterwards.

  - Add to Artifacts or an existing flow. Many flows could do with work
    to detect more things or support additional platforms.

  - Add a new parser to parse a new filetype, e.g. if you have a
    different Anti-virus or HIDS log you want to parse.
    
## Contributor License Agreement

GRR is an opensource project released under the [Apache
License](https://github.com/google/grr/blob/master/LICENSE) and you should feel
free to use it in any way compatible with this.  However, in order to accept
changes into the GRR mainline repository we must ask that keep a signed a
[Google Contributor License Agreement](https://cla.developers.google.com/clas)
on file.

## Style

The [Chromium](http://www.chromium.org/developers/contributing-code) and
[Plaso](http://plaso.kiddaland.net/developer/style-guide) projects have
some good general advice about code contributions that is worth reading.
In particular, make sure you’re communicating via the dev list before
you get too far into a feature or bug, it’s possible we’re writing
something similar or have already fixed the bug.

Code needs to conform to the [Google Python Style
Guide](http://google.github.io/styleguide/pyguide.html).
Note that despite what the guide says, we use two-space indentation, and
MixedCase instead of lower\_underscore for function names since this is
the internal standard. Two-space indentation also applies to CSS.

## Setup

We use the github [fork and pull review
process](https://help.github.com/articles/using-pull-requests) to review
all contributions.

First, fork the [GRR repository](https://github.com/google/grr) by
following [the github
instructions](https://help.github.com/articles/fork-a-repo).

Now that you have a github.com/your-username/grr repository:

    # Make a new branch for the bug/feature
    $ git checkout -b my_shiny_feature

    # Make your changes, add any new files
    $ git add newmodule.py newmodule_test.py

When you’re ready for review, [sync your branch with
upstream](https://help.github.com/articles/syncing-a-fork):

    $ git fetch upstream
    $ git merge upstream/master

    # Fix any conflicts and commit your changes
    $ git commit -a
    $ git push origin HEAD

Use the GitHub Web UI to [create and send the pull
request](https://help.github.com/articles/using-pull-requests). We’ll
review the change.

    # Make review changes
    $ git commit -a
    $ git push origin HEAD

Once we’re done with review we’ll commit the pull request.
