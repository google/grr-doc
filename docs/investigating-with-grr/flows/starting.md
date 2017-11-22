# Starting Flows

To start a new Flow simply click on the *Start new flows* option on the
left panel while having a client selected. The main panel will populate with the holy trinity of panels. The tree view shows all the Flows organized by category.

For example, in order to start a *FileFinder* flow,
expand the *FileSystem* category and select the corresponding item.
The flow view will populate with a form with all the user-configurable
parameters for this flow. What’s more, because each parameter has a
well-defined type, GRR shows you widgets to select a value for each
of them.

The FileFinder flow accepts a range parameters:

1.  *Paths*. This is a list of textual paths that you want to look at.

2.  *Pathtype*. Which VFS handler you want to use for the path.
    Available options are:

      - **OS**. Uses the OS "open" facility. These are the most
        straightforward for a first user. Examples of *os* paths are
        `C:/Windows` on Windows or `/etc/init.d/` on Linux/OSX.

      - **TSK**. Use Sleuthkit. Because Sleuthkit is invoked a path to
        the device is needed along the actual directory path. Examples
        of *tsk* paths are
        `\\?\Volume{19b4a721-6e90-12d3-fa01-806e6f6e6963}\Windows` for
        Windows or `/dev/sda1/init.d/` on Linux (But GRR is smart enough to figure out what you want if you use `C:\Windows` or `/init.d/` instead even though there is some guessing involved).

      - **REGISTRY**. Windows-related. You can open the live Windows
        registry as if it was a virtual filesystem. So you can specify
        a path such as `HKEY_LOCAL_MACHINE/Select/Current`.

      - **MEMORY** and **TMPFILE** are internal and should not be used in most cases.

3.  *Condition*. The *FileFinder* can filter files based on condition like file size or file contents. The different conditions should be self explanatory. Multiple conditions can be stacked, the file will only be processed if it fulfills them all.

4. *Action*. Once a file passes all the conditions, the action decides what should be done with it. Options are **STAT**, **HASH** and **DOWNLOAD**. Stat basically just indicates if a file exists, this is mostly used to list directories (path `C:\Windows\*` and action STAT). Hash returns a list of hashes of the file and Download collects the file from the client and stores it on the server.

For this example, a good set of arguments would be a directory listing, something like path `C:\Windows\*` or `/tmp/*` and action **STAT**. Once you’ve filled in each required field, click on *Launch* and if all
parameters validated, the Flow will run. Now you can go to the *Manage
launched flows* view to find it running or track it.

> **Important**
> Not all flows might be available on every platform. When trying to run
> a flow that’s not available in the given platform an error will show
> up.

### Available flows ###

The easiest ways to see the current flows is to check in the AdminUI under StartFlow. These have useful documentation.

Note that by default only BASIC flows are shown in the Admin UI. By clicking the settings (gear icon) in the top right, you can enable ADVANCED flows. With this set you will see many of the underlying flows which are sometimes useful, but require a deeper understanding of GRR.