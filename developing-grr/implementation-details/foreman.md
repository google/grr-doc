# Foreman

The Foreman is a client scheduling service. At a regular intervals
(defaults to every 30 minutes) the client will report in asking if there
are Foreman actions for it. At the time of this check in, the Foreman
will be queried to decide if there are any jobs that match the host, if
there are, appropriate flows will be created for the client. This
mechanism is generally used by Hunts to schedule flows on a large number
of clients.

The foreman maintains a list of rules, if the rule matches a client when
it checks in, the specified flow will execute on the client. The rules
work against client attributes allowing for things like "All XP Machines"
or "All OSX machines installed after 01.01.2011". For more information
see the section about [hunt rules](../../../investigating-with-grr/hunts/rules/).

The foreman check-in request is a special request made by the client. When the
server sees this request it does the following:

1.  Determines how long since this client did a Foreman check-in.

2.  Determines the set of rules that are non-expired and haven’t
    previously been checked by the client.

3.  Matches those rules against the client’s attributes to determine if
    there is a match.

4.  If there is a match, run the associated flow.

The reason for the separate Foreman check-in request is that the rule
matching can be expensive when you have a lot of clients, so having
these less frequent saves a lot of processing.
