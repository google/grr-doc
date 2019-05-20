# Client Path Specifications

One of the nice things about the GRR client is the ability to nest file
readers. For example, we can read files inside an image using the
sleuthkit and also directly through the API. We can read registry keys
using REGFI from raw registry files as well as using the API. The way
this is implemented is using a pathspec.

## Pathspecs

The GRR client has a number of drivers to virtualize access to different
objects, creating a Virtual File System (VFS) abstraction. These are
called *VFS Handlers* and they provide typical file-like operations
(e.g. read, seek, tell and stat). It is possible to recursively apply
different drivers in the correct order to arrive at a certain file like
object. In order to specify how drivers should be applied we use *Path
Specifications* or pathspecs.

Each VFS handler is constructed from a previous handler and a pathspec.
The pathspec is just a collection of arguments which make sense to the
specific VFS handler. The type of the handler is carried by the pathtype
parameter:

  - pathtype: OS
    Implemented by the grr.client.vfs\_handlers.file module is a VFS
    Handler for accessing files through the normal operating system
    APIs.

  - pathtype: TSK
    Implemented by the grr.client.vfs\_handlers.sleuthkit module is a
    VFS Handler for accessing files through the sleuthkit. This Handle
    depends on being passed a raw file like object, which is interpreted
    as the raw device.

A pathspec is a list of components. Each component specifies a way to
derive a new python file-like object from the previous file-like object.
For example, image we have the following pathspec:

    path:   /dev/sda1
    pathtype: OS
    nested_path: {
       path: /windows/notepad.exe
       pathtype: TSK
    }

This opens the raw device /dev/sda1 using the OS driver. The TSK driver
is then given the previous file like object and the nested pathspec
instructing it to open the /windows/notepad.exe file after parsing the
filesystem in the previous step.

This can get more involved, for example:

    path:   /dev/sda1
    pathtype: OS
    nested_path: {
       path: /windows/system32/config/system
       pathtype: TSK
       nested_path: {
          path: SOFTWARE/MICROSOFT/WINDOWS/
          pathtype: REGISTRY
      }
    }

Which means to use TSK to open the raw registry file and then REGFI to
read the key from it (note that is needed because you generally cant
read the registry file while the system is running).

## Pathspec transformations

The pathspec tells the client exactly how to open the required file, by
nesting drivers on the client. Generally, however, the server has no
prior knowledge of files on the client, therefore the client needs to
transform the server request to the pathspec that makes sense for the
client. The following are the transformations which are applied to the
pathspec by the client.

### File Case Correction and path separator correction

Some filesystems are not case sensitive (e.g. NTFS). However they do
preserve file cases. This means that the same pathspecs with different
case filename will access the same file on disk. This file however, does
have a well defined and unchanging casing. The client can correct file
casing, e.g.:

    path: c:\documents and settings\
    pathtype: OS

Is corrected to the normalized form:

    path: /c/Documents and Settings/
    pathtype: OS

### Filesystem mount point conversions

Sometimes the server requires to read a particular file from the raw
disk using TSK. However, the server generally does not know where the
file physically exists without finding out the mounted devices and their
mount points. This mapping can only be done on the client at request
runtime. When the top level pathtype is TSK, the client knows that the
server intends to read the file through the raw interface, and therefore
converts the pathspec to the correct form using the mount points
information. For example:

    path: /home/user/hello.txt
    pathtype: TSK

Is converted to:

    path: /dev/sda2
    pathtype: OS
    nested_path: {
          path: /user/hello.txt
          pathtype: TSK
    }

### UUIDs versus "classical" device nodes

External disks can easily get re-ordered at start time, so that path
specifiers containing /dev/sd? etc. may not be valid anymore after the
last reboot. For that reason the client will typically replace /dev/sda2
or similar strings with /dev/disk/by-uuid/\[UUID\] on Linux or other
constructions (e.g. pathtype: uuid) for all clients.

## Life of a client pathspec request

The figure below illustrates a typical request to the client - in this case to
list a directory:

1.  A ListDirectory Flow is called with a pathspec of:

        path: c:\docume~1\bob\
        pathtype: OS

2.  The flow sends a request for the client action ListDirectory with
    the provided pathspec.

3.  Client calls VFSOpen(pathspec) which opens the file, and corrects
    the pathspec to:

        path: c:\Documents and Settings\Bob\
        pathtype: OS

4.  Client returns StatResponse for this directory with the corrected
    pathspec.

5.  The client response maps to a defined location in the server data store. In
    this case a mapping is created for files read through the OS apis using the
    OS path type. Note that the path to access the created files contains the
    case corrected client paths:

        /fs/os/c/Documents and Settings/Bob

6.  The server now creates this object, and stores the corrected
    pathspec as an attribute.

Client pathspec conversions can be expensive so the next time the server uses
this object for a client request, the server can simply return the client the
corrected pathspec. The corrected pathspec has the LITERAL option enabled which
prevents the client from applying any corrections.
