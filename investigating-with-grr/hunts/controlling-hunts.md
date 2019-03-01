# Hunt Controls

### Create a new hunt

![new](../../images/icons/new.png)

Use this button to create a new hunt.

### Start a Hunt

![play button](../../images/icons/play_button.png)

Use this button to start a newly created hunt. New hunts are created in
the PAUSED state, so you’ll need to do this to run them. Hunts that
reach their client limit will also be set to PAUSED, use this button to
restart them after you have removed the client limit (see modify below).

### Stop a Hunt

![stop button](../../images/icons/stop.png)

Stopping a hunt will prevent new clients from being scheduled and
interrupt in-progress flows the next time they change state. This is a
hard stop, so in-progress results will be lost, but results already
reported are unaffected. Once a hunt is stopped, there is no way to start it again.


### Modify a Hunt

![modify](../../images/icons/modify.png)

The modify button allows you to change the hunt client limit and the
hunt expiry time. Typically you use this to remove (set to 0) or increase a client limit to let the hunt run on more machines. Modifying an existing hunt doesn’t require re-approval. Hunts can only be modified in the PAUSED state.

### Copy a Hunt

![modify](../../images/icons/copy.png)

The copy button creates a new hunt with the same set of parameters as the currently selected one. If you find a mistake in a scheduled hunt and have to stop it, this button can be used to quickly reschedule a fixed version of the hunt.

### Delete a Hunt

![editdelete](../../images/icons/editdelete.png)

Use this to remove an unwanted hunt. For accountability reasons hunts
can only be deleted if they haven’t run on any clients.

### Show automated hunts

![robot](../../images/icons/robot.png)

Use this button to display all hunts, including those created by
cronjobs. These are hidden by default to reduce UI clutter.
