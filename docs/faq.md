**Frequently Asked Questions**

# Who wrote GRR and Why?

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

# Why is the project called GRR?

When using other tools, we found ourselves making the sound "grrr" a
lot, and it just kind of stuck. GRR is a recursive acronym, in the
tradition of GNU and it stands for GRR Rapid Response. Not GRR Response
Rig or Google Rapid Response which it is sometimes mistaken for.

# Is GRR production ready?

As of Aug 2015 GRR is running at large scale both inside and outside of
Google. The largest opensource deployment we know of is roughly 30k
machines, there’s another company at around 15k, and quite a few around
2k. Google’s deployment is bigger than all of those put together,
although there are some differences in the codebase (see below).

# Should I expect to be able to install and just start running GRR?

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

# Can the GRR team provide me with assistance in getting it setup?

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
