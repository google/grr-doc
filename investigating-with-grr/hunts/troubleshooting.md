# Troubleshooting ("Why is my hunt doing nothing?")

  - There are caches involved in the frontend server, you may need to
    wait a couple of minutes before the first client picks up the flow.

  - Clients only check if there is hunt work to do when doing a foreman
    check. The frequency of these checks are specified in the
    `Client.foreman_check_frequency` parameter. This defaults to
    every 30 minutes.

  - Even when a client issues a foreman check, the flows may not
    immediately start. Instead, the process is asynchronous, so the
    check tells the server to check its hunt rules to see if there are
    things for the client to do. If there are, it schedules them, but
    the client may not do its regular poll and pick up that flow until
    `Client.poll_max period` (10 minutes by default).

  - When you run a hunt you can specify a "Client Rate" as specified
    in [creating hunts](starting.md). If this is set low (but not 0), you can expect a slow hunt.

  - When running a hunt under high server load, clients seem appear
    complete in batches. This results in the completion graph appearing
    "stepped". The clients are finishing normally, but their results are
    being processed and logged in batches by the Hunt. When the system
    is under load, this hunt processing takes some time to complete
    resulting in the *steps*.
