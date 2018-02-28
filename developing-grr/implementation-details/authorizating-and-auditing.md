# Authorization and Auditing

GRR contains support for a full authorization and audit API (even for
console users) and is implemented in an abstraction called a Security
Manager. This Security Manager shipped with GRR, does
not make use of these APIs and is open by default. However, a deployment
may build their own Security Manager which implements the authorization
semantics they require.

This infrastructure is noticeable throughout much of the code, as access
to any data within the system requires the presence of a "token". The
token contains the user information and additionally information about
the authorization of the action. This passing of the token may seem
superfluous with the current implementation, but enables developers to
create extensive audit capabilities and interesting modes of
authorization.

By default, GRR should use data\_store.default\_token if one is not
provided. To ease use this variable is automatically populated by the
console if --client is used.

Token generation is done using the access\_control.ACLToken.

``` python
token = access_control.ACLToken()
fd = aff4.FACTORY.Open("aff4:/C.12345/", token=token)
```
