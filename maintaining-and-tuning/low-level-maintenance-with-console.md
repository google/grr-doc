# Low-level maintenance with grr_console

GRR is shipped with a *grr_console* binary. This is effectively an IPython shell that gets initialized with a few basic GRR objects and offers you direct access to internal GRR classes.

In cases when there's no proper tool or UI or API for performing a certain task, grr_console may be useful. However, given that it exposes undocumented GRR internals and gives you complete unrestricted and unaudited access to GRR datastore, it's important to remember that:

1. It's very easy to shoot yourself in the foot and make the system unusable by running a wrong piece of code in *grr_console*.
1. GRR is a project that's being actively developed. Class names, import paths, interfaces are changing all the time. Even if you have a snippet of code that works in *grr_console* today, it may stop working in a month.

## Console Snippets (might break any time)

### Delete a client from the database

```python
In [1]: print data_store.REL_DB.ReadClientSnapshot(u"C.83558528f50f993e").knowledge_base.fqdn
example.host.com

In [2]: data_store.REL_DB.DeleteClient(u"C.83558528f50f993e")

```

### Delete all signed binaries from the database

```python
In [1]: ids = data_store.REL_DB.ReadIDsForAllSignedBinaries()

In [2]: for i in ids:
   ...:     data_store.REL_DB.DeleteSignedBinaryReferences(i)
   ...:     

```
