# Grep Syntax

A number of GRR flows (such as the File Finder) accept
Grep specifications, which are a powerful way to search file and memory
contents. There are two types of grep syntax: literal and regex.

## Literal Matches

Use this when you have a simple string to match, or want to match a byte
string. Here’s a simple string example (note no quotes required):
```docker
allyourbase
```

And a byte string example:
```docker
MZ\x90\x00\x03\x00\x00\x00\x04\x00\x00\x00
```

To minimise the potential for errors we recommend using python to create
byte strings for you where possible, e.g. the above byte string was
created in ipython like this:

```
In [1]: content = open("test.exe","rb").read(12)

In [2]: content
Out[2]: 'MZ\x90\x00\x03\x00\x00\x00\x04\x00\x00\x00'
```

## Regex Matches

Use this when you need more complex matching. The format is a regular
python regex (see <http://docs.python.org/2/library/re.html>) with the
following switches applied automatically:

```docker
re.IGNORECASE | re.DOTALL | re.MULTILINE
```

An example regex is below. The entire match is reported, () groups are
not broken out separately. Also note that 10 bytes before and after will
be added to any matches by default - use the Advanced menu to change
this behavior:

```
Accepted [^ ]+ for [^ ]+ from [0-9.]+ port [0-9]+ ssh
```