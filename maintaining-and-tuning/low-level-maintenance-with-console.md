# Low-level maintenance with grr_console

GRR is shipped with a *grr_console* binary. This is effectively an IPython shell that gets initialized with a few basic GRR objects and offers you direct access to internal GRR classes.

In cases when there's no proper tool or UI or API for performing a certain task, grr_console may be useful. However, given that it exposes undocumented GRR internals and gives you complete unrestricted and unaudited access to GRR datastore, it's important to remember that:

1. It's very easy to shoot yourself in the foot and make the system unusable by running a wrong piece of code in *grr_console*.
1. GRR is a project that's being actively developed. Class names, import paths, interfaces are changing all the time. Even if you have a snippet of code that works in *grr_console* today, it may stop working in a month.

## Console Snippets (might break any time)

### Delete a client from the database

```python
In [1]: client = o("C.0a2d3036f8e0c4be")

In [2]: print client.Get(client.Schema.HOSTNAME)
example.host.com

In [3]: aff4.FACTORY.Delete("C.0a2d3036f8e0c4bf")

```
