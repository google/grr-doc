# Hunt Limits, DOs and DONTs

## Creating Hunts ##

As already outlined in the section about [creating hunts](starting.md), hunts might negatively impact both the client machines they run on and also the GRR system by causing extensive load. In order to prevent this, we recommend to always start hunts either by

- copying an existing and tested flow or
- copying an existing hunt, applying only minor modifications.

We realize that sometimes unexpected problems can still arise and therefore GRR applies some limits to hunts.

## Default Hunt Limits

There are two sets of limits in place for hunts. GRR enforces both, limits on individual clients and limits on the average resource usage for the hunt.

### Individual Client Limits

Analoguous to what happens with flows, GRR enforces limits on the resource usage for each client participating in a hunt. Since the impact of a hunt is potentially much larger than for a single flow, the limits for hunts are lower than the flow limits. The current defaults are:

- 600 cpu seconds per client
- 100 MB of network traffic per client

### Limits on Average Resource Usage

Once a hunt has processed 1000 clients, the average resource usage is also checked and enforced by GRR. The defaults for those limits are:

- 1000 results on average per client
- 60 cpu seconds on average per client
- 10 MB of network traffic on average per client

All the limits in this section can be overridden in the advanced settings when scheduling hunts. Use at your own risk.
