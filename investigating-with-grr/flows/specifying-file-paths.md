# Specifying File Paths

Providing file names to flows is a core part of GRR, and many flows have
been consolidated into the File Finder flow, which uses a
glob+interpolation syntax.

## File Path Examples

All executables or dlls in each user’s download directory:

```docker
%%users.homedir%%\Downloads\*.{exe,dll}
```

All .evtx files found up to three directories under
"C:\Windows\System32\winevt":

```docker
%%environ_systemroot%%\System32\winevt\**.evtx
```

"findme.txt" files in user homedirs, up to 10 directories deep:

```docker
%%users.homedir%%/**10/findme.txt
```

## File Paths: backslash or forward slash?

Either forward "/home/me" or backslash "C:\\Users\\me" path
specifications are allowed for any target OS. They will be converted to
a common format internally. We recommend using whatever is normal for
the target OS: (backslash for Windows, fwdslash for OS X and Linux).

## File Path Interpolation

GRR supports path interpolation from values in the artifact Knowledge
Base. Interpolated values are enclosed with %%, and may expand to
multiple elements. e.g.

```
%%users.homedir%%
```

Might expand to the following paths on Windows:

```docker
C:\Users\alice
C:\Users\bob
C:\Users\eve
```

and on OS X:

```docker
/Users/alice
/Users/bob
/Users/eve
```

and on Linux:

```docker
/home/alice
/usr/local/home/bob
/home/local/eve
```

A full list of possible interpolation values can be found by typing %%
in the gui. The canonical reference is the
[proto/knowledge\_base.proto](https://github.com/google/grr/blob/master/grr/proto/grr_response_proto/knowledge_base.proto) file, which also contains docstrings for each type.

## Path Globbing

Curly braces work similarly to bash, e.g:

```docker
{one,two}.{txt,doc}
```

Will match:
```docker
one.txt
two.txt
one.doc
two.doc
```


Recursive searching of a directory is performed with `**`. The default
search depth is 3 directories. So:

```docker
/root/**/*.doc
```

Will match:

```docker
/root/blah.doc
/root/1/something.doc
/root/1/2/other.doc
/root/1/2/3/another.doc
```

More depth can be specified by adding a number to the `**`, e.g. this
performs the same search 10 levels deep:

```docker
/root/**10/*.doc
```

It can also be combined with interpolation.

The following statement:

```
%%environ_systemdrive%%\**5\FOOBAR
```

Will match:

```
C:/1/FOOBAR
C:/1/2/FOOBAR
C:/1/2/3/FOOBAR
```

> **IMPORTANT:** Due to a [regression](https://github.com/google/grr/issues/915), the recursive glob `**` behaves differently in ClientFileFinder. This will be fixed in a future version.
> 
> **Note:** FileFinder transfers all data to the server and does the matching server side. This might lead to terrible performance when used with deep recursive directory searches. For a faster alternative that has the drawback of leaking the path you are searching for to the potentially compromised client, use the *ClientFileFinder* flow which does the matching right on the client.
