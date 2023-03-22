# Frequently Asked Questions

## Who wrote GRR and Why?

GRR started at Google as a 20% project and gained in popularity until it
became fully-supported and open sourced. The primary motivation was that
we felt the state of the art for incident response was going in the
wrong direction, and wasn’t going to meet our cross platform,
scalability, obfuscation or flexibility goals for an incident response
agent.

Additionally, we believe that for things to progress in security,
everyone has to up their game and improve their capabilities. We hope
that by open sourcing GRR, we can foster development of new ways of
doing things and thinking about the problem, get it into the hands of
real organizations at reasonable cost, and generally push the state of
the art forward.

We are getting significant code contributions from outside of Google,
and have close relationships with a number companies running large-scale
deployments.

## Why is the project called GRR?

When using other tools, we found ourselves making the sound "grrr" a
lot, and it just kind of stuck. GRR is a recursive acronym, in the
tradition of GNU and it stands for GRR Rapid Response. Not GRR Response
Rig or Google Rapid Response which it is sometimes mistaken for.

## Is GRR production ready?

As of Aug 2015 GRR is running at large scale both inside and outside of
Google. The largest opensource deployment we know of is roughly 30k
machines, there’s another company at around 15k, and quite a few around
2k. Google’s deployment is bigger than all of those put together,
although there are some differences in the codebase (see below).

## Should I expect to be able to install and just start running GRR?

Yes, for basic use cases.

But if you want to do a large-scale enterprise deployment, it is
probably best to think about GRR as a 80% written software project that
you could invest in. The question then becomes: instead of investing X
million in product Y to buy something, should I instead invest 25% of
that in GRR and hire a dev to contribute, build and deploy it? On the
one hand that gives you control and in-house support, on the other, it
is a real investment of resources.

If you are selling GRR internally (or to yourself) as a free \<insert
commercial IR product here\>, your expectations will be wrong, and you
may get disillusioned.

## Can the GRR team provide me with assistance in getting it setup?

The core GRR team cares about the open source project, but in the end,
our main goals are to build something that works for us. We don’t, and
won’t offer a helpdesk, professionally curated documentation, nor
someone you can pay money to help you out if something goes wrong. We
aren’t providing feeds or consulting services, and have nothing direct
to gain from offering the platform. If you need something pre-packaged
and polished, GRR probably isn’t right for you (at least in the
short-medium term). For a large deployment you should expect to fix
minor bugs, improve or write documentation, and actively engage with the
team to make it successful.

If someone is willing to code, and has invested some time learning we
will do what we can to support them. We’re happy to spend time on VC or
in person helping people get up to speed or running hackathons. However,
the time that the developers invest in packaging, building, testing and
debugging for open source is mostly our own personal time. So please be
reasonable in what and how you ask for assistance. We’re more likely to
help if you’ve contributed documentation or code, or even filed good bug
reports.

## I’m interested in GRR but I, or my team need some more convincing. Can you help?

The core GRR team has invested a lot in the project, we think its pretty
awesome, so the team happy to talk, do phone calls, or chat with other
teams that are considering GRR. We’ve even been known to send
house-trained GRR engineers to companies to talk with interested teams.
Just contact us directly. You also can corner one of us, or at least
someone from the team, or someone who works on GRR at most leading
forensics/IR type conferences around the
world.

## I’ve heard that there are secret internal versions of GRR that aren’t open sourced that may have additional capabilities. Is that true?

GRR was always designed to be open sourced, but with any sufficiently
complex "enterprise" product you expect to integrate it with other
systems and potentially even with proprietary technology. So its true
that some of the core developers time is spent working on internal
features that won’t be released publicly. The goal is to ensure that
everything useful is released, but there are some things that don’t make
sense. Below are listed some of the key differences that may matter to
you:

  - **Datastore/Storage**: At Google we run GRR on a Bigtable datastore
    (see below for more detail), but we have abstracted things such that
    using a different datastore is very simple. The MySQLAdvanced datastore
    is available to open source are actively used at real scale outside
    of Google.

  - **Security and privacy**: The open source version has minimal
    controls immediately available for user authentication, multi-party
    authorization, privacy controls, logging, auditing etc. This is
    because these things are important enough for them to be custom and
    integrated with internal infrastructure in a large deployment. We
    open source the bits that make sense, and provide sensible hooks for
    others to use, but full implementations of these may require some
    integration work.

  - **Machine handling and monitoring**: Much of the infrastructure for
    running and monitoring a scalable service is often built into the
    platform itself. As such GRR hasn’t invested a lot in built-in
    service or performance monitoring. We expose a lot of statistics,
    but only display a small subset in the UI. We expect companies to
    have package deployment (SCCM/munki/casper/apt/yum etc.), config
    management (chef/puppet/salt etc.), and server monitoring
    (nagios/cacti/munin/zabbix/spiceworks etc.).

Differences will be whittled away over time as the core GRR team runs
open source GRR deployments themselves. That means you can expect most
of these things to become much less of an issue over time.

## Why was support for SQLite dropped?

Our intent for SQLite was for it to be used as a casual, easy-setup datastore
for testing/evaluating GRR. It doesn't scale well, and is not recommended
for actual production use. When developing GRR's new relational database
model, we decided that continuing to have support for SQLite was not worth
the engineering effort it would take to build a SQLite implementation of
the new model.

## I heard GRR was designed for Bigtable and now Google has a Cloud Bigtable service. Can I use it?

Internally we use Bigtable, but the internal API is very different so
the code cannot be used directly. The [Cloud Bigtable
service](https://cloud.google.com/bigtable/docs/) uses an extension of
the HBase API. We’d like to write a GRR database connector that can use
this service, but (as at Aug 2015) the Bigtable service is still in Beta
and the python libraries to interact with it are still being developed,
so it isn’t currently a high priority.

## What operating system versions does the client support?

We try to support a wide range of operating systems because we know it’s
often the old forgotten machines that get owned and need GRR the most.
Having said that ‘support’ is minimal for very old operating systems,
we’re a small team and we don’t have the time to test the client on
every possible combination. So the approach is basically to try and keep
support for old systems by building compiled dependencies in a way that
should work on old systems.

**Windows**

  - Well tested on: 64bit Windows 7+ workstations, 64bit Win2k8+
    servers.

  - Should probably work: 32bit versions of the above, Windows Vista+
    workstations. (We've stopped building and releasing 32bit versions
    since release 3.4.0. It should be possible to build a client from source
    though.)

**OS X**

  - Well tested on: 64bit 10.8 (Mountain Lion)+ Note that 10.11 (El
    cap)+ systems require a 3.0.7.1+ client due to the [OS X System
    Integrity Protection
    changes](https://derflounder.wordpress.com/2015/10/01/system-integrity-protection-adding-another-layer-to-apples-security-model/).
    And sleuthkit [hasn’t caught
    up](https://github.com/sleuthkit/sleuthkit/issues/402) to
    [filesystem
    changes](https://github.com/sleuthkit/sleuthkit/issues/401) from
    Yosemite onwards. The compiler we use to build the Mac client
    template has become more aggressive with optimizations and now emits
    code optimized to specific processor versions. The mac client will
    not run on a processor older than our build machine - an early 2011
    Macbook with the Intel Sandy Bridge architecture. If you need to run
    GRR on, for example, Core 2 duo machines, you will need a custom
    client built on one of those machines.

**Linux**

  - Well tested on: 64bit Ubuntu Lucid+, CentOS 5.11+

  - Should probably work: 32bit versions of the above, and essentially
    any system of similar vintage that can install a deb or rpm.

## What operating system versions does the server support?


We only support 64bit Ubuntu 22.04.

We don’t provide a 32-bit server version since standing up new 32-bit
linux servers is not something rational people do, and there are many
places you can get 64-bit virtual servers for ~free. We use the "amd64"
notation, but this just means 64-bit, it runs fine on Intel.

## What hardware do I need to run GRR?

This is actually a pretty tough question to answer. It depends on the
database you choose, the number of clients you have, and how intensively
you hunt. Someone who wants to do big collection hunts (such as sucking
all the executables out of System32) will need more grunt and storage
than someone who mainly wants to check for specific IOCs and investigate
single machines.

But to give you some data points we asked some of the GRR users with
large production installs about the hardware they are using (as at
October 2015) and provide it here below:

**32k clients**:

  - Workers: AWS m4.large running 3 worker processes

  - HTTP frontends: 6-10 x AWS m4.large. Sits behind an AWS Elastic Load
    Balancer.

  - Datastore (SQLite): 5 x AWS m4.2xlarge. m4.2xlarge is used when
    running intensive enterprise hunts. During normal usage, m4.large is
    fine.

  - AdminUI: 1 m3.large

**15k clients**:

  - Workers and HTTP frontends: 10 x 4 core 8GB RAM virtual servers
    running 1 worker + 1 frontend each

  - Datastore (MySQLAdvanced): 16 core 256G ram 8x10k drives. 128G RAM
    was sufficient, but we had the opportunity to stuff extra RAM in so
    we did.

  - AdminUI: 12 core 24G RAM is where we left the UI since it was spare
    hardware and we had a lot of active users and the extra RAM was nice
    for faster downloads of large datasets. It was definitely overkill
    and the backup was on a 4 core 8GB of RAM VM and worked fine during
    maintenance stuff.

**7k clients**:

Run in AWS with c3.large instances in two autoscaling groups.

  - Workers: 4 worker processes per server. The weekly interrogate flow
    tends to scale up the servers to about 10 systems, or 40 workers,
    and then back down in a couple of hours.

  - HTTP frontends and AdminUI: Each server has apache running a reverse
    proxy for the GRR AdminUI. At idle it uses just a t2.small, but
    whenever there is any tasking it scales up to 1-3 c3.large
    instances. Sits behind an AWS Elastic Load Balancer.

  - Datastore (MySQLAdvanced): AWS r3.4xlarge RDS server. RDS instance
    is optimized for 2000 IOPS and we’ve provisioned 3000.

## How do I handle multi-organisational deployments?

[Bake labels into clients at build
time](admin.md#building-clients-with-custom-labels-multi-organization-deployments),
and use a "Clients With Label" hunt rule to hunt specific groups of
clients separately.

## Which cloud should I deploy in? GCE? EC2? Azure?

Google Compute Engine (GCE) of course :) We’re working on making cloud
deployment easier by dockerizing and building a click-to-deploy for GCE.
Our focus will be primarily on making this work on GCE, but moving to a
docker deployment with orchestration will simplify deployment on all
clouds. The largest cloud deployments of GRR are currently on EC2, and
we hope the community will be able to share configuration and HOWTOs for
this and other cloud deployments.

## Where/how do you do your data analysis?

We mostly do this outside of GRR using an internal system very similar
to [BigQuery](https://cloud.google.com/bigquery/what-is-bigquery). GRR supports
[Output Plugins](investigating-with-grr/output-plugins.md) that send hunt results
to other systems (e.g. BigQuery, Splunk) with minimal delay.

## When will feature X be ready?

Generally our roadmap on the main project page matches what we are
working on, but we reserve the right to miss those goals, work on
something entirely different, or sit around a fire singing kumbaya. Of
course, given this is open source, you can add the feature yourself if
it matters.

## Who is working on GRR?

GRR has around 5 full-time software engineers working on it as their day
job, plus additional part time code contributors. The project has long
term commitment.

## Why aren’t you developing directly on open source?

Given we previously had limited code contribution from outside, it was
hard to justify the extra effort of jumping out of our internal code
review and submission processes. That has now changed, we are syncing
far more regularly (often multiple times per week), and we are working
on code structure changes that will make it easier for us to develop
externally.

## Why is GRR so complicated?

GRR **is** complicated. We are talking about a distributed,
asynchronous, cross platform, large scale system with a lot of moving
parts. Building that is a hard and complicated engineering problem. This
is not your average pet python project.

Having said that, the most common action of just collecting something
from machines and parsing what you get back has been made significantly
easier with [the artifacts
system](user_manual.md#artifacts).
This allows you to specify complex multi-operating system collection
tasks with just a few lines of YAML, and collect any of the hundreds of
pre-defined forensic artifacts with the click of a button.

## What are the commercial competitors to GRR?

Some people have compared GRR functionality to Mandiant’s MIR, Encase
Enterprise, or F-Response. There is some crossover in functionality with
those products, but we don’t consider GRR to be a direct competitor. GRR
is unlikely to ever be the product for everyone, as most organizations
need consultants, support and the whole package that goes with that.

In many ways we have a way to go to match the capabilities and ease of
use of some of the commercial products, but we hope we can learn
something off each other, we can all get better, and together we can all
genuinely improve the security of the ecosystem we all exist in. We’re
happy to see others use GRR in their commercial consulting practices.

## Where is the logout button?

There isn’t one. We ship with basic auth which [doesn’t really handle
logout](http://stackoverflow.com/questions/233507/how-to-log-out-user-from-web-site-using-basic-authentication),
you need to close the browser. This is OK for testing, but for
production we expect you to sit a reverse proxy in front of the UI that
handles auth, or write a webauth module for GRR. See the [Authentication
to the
AdminUI](admin.md#authentication-to-the-admin-ui)
section for more details.

## How do I change the timezone from UTC?

You can’t. Technically it’s possible, but it’s a lot of work and we
don’t see much benefit. You should run your GRR server in the UTC
timezone.

In the datastore GRR stores all timestamps as microseconds from epoch
(UTC). To implement timezone customization we could store a user’s local
preference for timezone and daylight savings based on a location, and
convert all the timestamps in the UI, but there is a lot of complexity
involved. We’d need to make sure each user gets the correct time and
timezone displayed in all parts of the UI, handle the shifting winds of
daylight savings correctly, provide clear input options on forms that
accept timestamps, and make sure all the conversions were correct. All
of that adds up to lots of potential to display or store an incorrect
time, which is not what you want from a forensics tool.

It’s common to have GRR users split across different timezones and a
client fleet in many timezones. If we went to all of the effort above,
all we have really achieved is fragmentation of each user’s view of the
system. Each user is still going to have to analyse and reason about
events on clients in a different timezone to their own. But now we have
made collaborative analysis harder: instead of being able to simply copy
a timestamp out of the UI into a ticket or handoff timeline analysis
notes to another shift in another timezone they will have to convert
timestamps back into UTC manually for consistency.

For forensic analysis and timeline building, UTC always makes the most
sense. We have added a UTC clock to the top right hand corner of the UI
to help reason about the timestamps you see.

## Is there any relation between the [grr](https://pypi.python.org/pypi/grr) pip package and Google's GRR?

No. The naming collision is just a coincidence, and you might actually
run into [issues](https://github.com/google/grr/issues/572) if you install
the two in the same Python environment.
