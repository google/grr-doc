# Release notes

Each release of GRR brings some significant changes as the project’s
code is moving quickly. This page tries to identify the key changes
and issues to watch for when upgrading from one version to another.

Note that since the 3.2.0.1 release, client and server releases are no
longer done separately (server debs include client templates).

Remember to back up your data-store and configs before upgrading GRR to a
new version.

## Server

### 3.4.6.0 (May 30 2022)

Regular release for Q2 2022.

 - UIv2 “files and flows” Launch
   - Search and collect files, browse collected files (former VFS)
   - List directory processes and network connections
   - Scan and dump memory
   - Launch binary, execute python hacks
   - Collect timeline, browser history and artifacts
 - UIv2 Canary feature: create hunts from existing flows!
 - New Feature: `Read low level` flow and client action. Use it to read raw data from disk.
 - Small bug fixes and refactors.

*Note: This will be the last release where GRR supports the Legacy Communication protocol. From the next release onwards, expect GRR to communicate only via [Fleetspeak](https://grr-doc.readthedocs.io/en/latest/fleetspeak/index.html) (more details to follow before the next release).*

*Note: This will be the last release based on Python 3.6.*

### 3.4.5.1 (August 19 2021)

Mid-quarter release for Q3 2021.

 - Sandboxing in the GRR client: TSK, libfsntfs and YARA libraries are now run in a separate, unprivileged process. This uses an unprivileged user and network/IPC namespaces on Linux, an unprivileged user in combination with `sandbox_init` on macOS, and [AppContainer Isolation](https://docs.microsoft.com/en-us/windows/win32/secauthz/appcontainer-isolation) on Windows.
 - Fleetspeak, the next generation communication framework, is now enabled by default. It's still possible to enable the deprecated, legacy communication framework via `grr_config_updater`.
 - New MSI installer for Windows clients. The old, self-extracting ZIP exe is now deprecated.
 - `ListNamedPipes`: New flow for named pipe collection on Windows.
 - Ongoing progress on the UIv2: early version of the next generation UI can be checked via the `<admin ui address>/v2` URL.

### 3.4.3.1 (May 19 2021)

Regular release for Q2 2021.

- Prometheus/Grafana [support](https://grr-doc.readthedocs.io/en/latest/maintaining-and-tuning/monitoring.html).
- New flow: "Collect large file" that uploads a given path to Google Cloud Storage using a given signed URL.
- New output plugin: Elasticsearch (thanks micrictor@ for the [contribution](https://github.com/google/grr/pull/923)!)
- Fleetspeak-enabled setups now use streaming connections by default (agents keep connections open, thus reducing latency from ~5 minutes to under 1 minute).
- API changes:
  - Introduced KillFleetspeak, RestartFleetspeakGrrService, DeleteFleetspeakPendingMessages, GetFleetspeakPendingMessages, GetFleetspeakPendingMessageCount API methods to provide Fleetspeak-specific capabilities for Fleetspeak-enabled clients.
  - Introduced ListParsedFlowResults and ListFlowApplicableParsers API methods for on-demand artifacts parsing.
- Bugfixes and various minor enhancements:
  - Osquery doesn't report results if the client returns an empty dataset.
  - Additional options can be specified when downloading timelines.
  - Introduced Hunt.default_client_rate configuration option.
  - Added Cron.interrogate_client_rate config option (defaults to 50).
- Ongoing work on the UIv2: very early version of the next-gen UI can be checked via the `<admin ui address>/v2` URL.

*Note: this is the last release where Fleetspeak is considered an experimental feature. Next release is going to use Fleetspeak as a default option (while still keeping the legacy communication protocol as a deprecated option).*

### 3.4.2.4 (October 14 2020)

Minor bug-fix release on top of v3.4.2.3.

- `grr_config_updater`: Fixed a bug where the fleetspeak MySQL password setting
  was not applied correctly. Fleetspeak was effectively always using an empty
  MySQL password when connecting to the database.

### 3.4.2.3 (October 01 2020)

Quarterly release for Q3 2020.

- GRR API:
  - [Reference documentation](https://storage.googleapis.com/autobuilds-grr-openapi/documentation/openapi_documentation.html) is now available.
  - An [OpenAPI spec](https://storage.googleapis.com/autobuilds-grr-openapi/openapi_description/openapi_description.json) is now available.
  - [Support](https://storage.googleapis.com/autobuilds-grr-openapi/documentation/openapi_documentation.html#operation/CreatePerClientFileCollectionHunt) for starting file collection hunts involving multiple explicitly specified hosts is now available.
  - `ArtifactCollectorFlowArgs`, `ArtifactFilesDownloaderFlowArgs`:
    - `use_tsk` is now deprecated in favor of `use_raw_filesystem_access`
    - `use_tsk` will be kept for compatibility until 2021-04-01, existing users should migrate to using `use_raw_filesystem_access`
- The `NTFS` [virtual file system](https://grr-doc.readthedocs.io/en/latest/investigating-with-grr/vfs/virtual-file-system.html) handler using [libfsntfs](https://github.com/libyal/libfsntfs) is now the default for raw filesystem access on Windows. The `TSK` handler is being deprecated.
- Experimental bundled [fleetspeak](https://github.com/google/fleetspeak) (next generation communication framework) is now available on all platforms. This can be enabled using `grr_config_updater`.
- Timeline collection flow now also collects the file creation timestamp on all platforms.
- Flow and Hunt IDs now have a length of 16 hexadecimal digits.
- A workaround for a [bug](https://bugs.python.org/issue41179) in `find_library` affecting macOS 11 has been added.
- Bugfixes and various enhancements.


### 3.4.2.0 (July 06 2020)

Quarterly release for Q2 2020.

- New flows:
  - [`TimelineFlow`](https://grr-doc.readthedocs.io/en/latest/investigating-with-grr/vfs/timelines.html#timelineflow) for collecting a snapshot of an entire filesystem.
  - `CollectEfiHashes` and `DumpEfiImage` flows for macOS investigations.
- New [SplunkOutputPlugin](https://grr-doc.readthedocs.io/en/latest/investigating-with-grr/output-plugins.html#splunk) to export Flow/Hunt results to Splunk.
- New NTFS [virtual file system](https://grr-doc.readthedocs.io/en/latest/investigating-with-grr/vfs/virtual-file-system.html) handler for file system parsing using [libfsntfs](https://github.com/libyal/libfsntfs).
- Support for [custom Email addresses](https://grr-doc.readthedocs.io/en/latest/maintaining-and-tuning/email-configuration.html#custom-email-addresses) for GRR users. [#555](https://github.com/google/grr/issues/555).
- Support pre-filling the approval reason text field by appending `?reason=<pre-filled reason>` to GRR URLs.
- API Changes:
  - All GRR Protocol Buffers messages now have proper package declarations.
  - New method `GetVersion`.
  - API shell now validates GRR server version and fails if the API client is too old. (This can be disabled using the `--no-check-version` flag.)
- Experimental bundled [fleetspeak](https://github.com/google/fleetspeak) (next generation communication framework) on Debian server / clients. This can be enbled using `grr_config_updater`.
- Bugfixes and various enhancements.

### 3.4.0.1 (December 18 2019)

**This is a first fully Python 3-based release.**

- GRR server debian package now has to be installed on Ubuntu 18.
- UpdateClient flow fixed for Ubuntu clients (see https://github.com/google/grr/issues/720).
- A number of bugfixes and minor enhancements for YARA memory scanning.

### 3.3.0.8 (October 9 2019)

**NOTE: Last Python 2-based release: further releases are expected to be Python 3-only.**

Minor bug-fix release. 

- A number of REL_DB issues discovered since the last release fixed.
- YARA scanning fixes and enhancements.
- Using latest (in most cases) versions of dependencies (applies to both Python and JS).

### 3.3.0.4 (July 3 2019)

Minor bug-fix release.

- Resolved an issue with approvals [#719](https://github.com/google/grr/issues/719).
- Resolved an issue with AdminUI failing when notification button was clicked, 
  but no unread notifications were present.

### 3.3.0.3 (July 1 2019)

Minor bug-fix release.

- Resolved an issue with client labels removal [#716](https://github.com/google/grr/issues/716).

### 3.3.0.2 (June 28 2019)

Just a small bug-fix release.

- Resolved stability issues in the MySQL backend [#712](https://github.com/google/grr/issues/712).
- Improved hostname handling [#713](https://github.com/google/grr/issues/713).
- Resolved `BigQueryOutputPlugin` failures [#714](https://github.com/google/grr/issues/714).
- Fixed issues with escaping path backslashes [#715](https://github.com/google/grr/issues/715).

### 3.3.0.0 (May 22 2019)

- [IMPORTANT] This is the first GRR release that works with the 
  **new relational data model**. The legacy, AFF4-based data store is still available 
  in this release but new GRR setups are encouraged to switch to the relational 
  data store. Please see the [documentation](https://grr-doc.readthedocs.io/en/v3.3.0/maintaining-and-tuning/grr-datastore.html)
  for details.
- Rekall memory forensics support has been dropped from GRR. GRR still offers process
  memory acquisition and process memory scanning using the Yara library.
- This release contains basic osquery integration for clients that have osquery 
  preinstalled.
- Custom monitoring code was removed in favor of prometheus.io integration.
- Tons of small (and not-so-small) bug fixes and code health improvements.
- API updates
    - *ListFlowOutputPluginsLogs*, *ListFlowOutputPluginErrors*, 
      *ListHuntOutputPluginLogs* and *ListHuntOutputPluginErrors* API calls now always 
      report *batch_index* and *batch_size* as 0 and no longer include *PluginDescriptor*
      into the reply.
    - *ListHuntCrashes* method no longer accepts the "filter" argument.
    - *ListHunts* no longer fills the "total_count" attribute of *ApiListHuntsResult*.
    - The *ApiHunt* protobuf no longer has an *expires* field. Instead, a *duration* 
      field has been added which can be used to calculate the expiration date as 
      *start_time + duration*. Note that if the hunt hasn't been started, it does not 
      have a *start_time* and, in consequence, it does not have an expiry time either.
    - The *ApiModifyHuntArgs* protobuf no longer has an *expires* field. Instead,
      a *duration* field has been added.
    - The artifact field of *ApiUploadArtifactArgs* no longer accepts an arbitrary
      byte stream but only proper strings. Since this field is ought to be the artifact
      description in the YAML format and YAML is required to be UTF-8 encoded, it makes
      no sense to accept non-unicode objects.


### 3.2.4.6 (Dec 20 2018)
This is just a small off-schedule release with some bugfixes.
- Fixed a unicode bug that prevented Windows clients with non-latin usernames
  from checking in.
- Fixed a bug in the `grr_config_updater generate_keys` command.

### 3.2.4.5 (Dec 17 2018)
- [IMPORTANT] This release is the last GRR release to work on a legacy
  AFF4-based datastore. Next generation datastore will also work on top of MySQL
  but will have a completely different schema, meaning that you’ll lose
  historical data with the next GRR upgrade (unfortunately we can’t provide data
  migration tools).
- [IMPORTANT] This release is the last GRR release to still include deprecated
  Rekall support. It will be removed completely with the next GRR release.
- Dropped support for SQLite datastores. Current users with SQLite deployments
  will have to migrate to MySQL when upgrading. Please note that GRR does not
  offer any functionality for migrating data from SQLite databases to MySQL. The
  setup process for MySQL datastores has been revamped, and is easier and more
  intuitive now. Users will have the option of aborting installation if MySQL is
  not installed on a target system, and GRR will now proactively and
  transparently attempt to connect to a MySQL instance during initialization.
- Improvements to the Python package structure.
- A lot of Python 3-compatibility improvements.
- Implementation of client-side artifact collector that tremendously improves
  latency of artifact collection.
- Tons of small (and not-so-small) bug fixes and code health improvements.

#### API updates
- Renamed the `task_eta` field of the `ApiClientActionRequest` object to
  `leased_until`.
- Got rid of `ListCronJobFlows` and `GetCronJobFlow` in favor of
  `ListCronJobRuns` and `GetCronJobRun`. `ListCronJobRuns`/`GetCronJobRun`
  return `ApiCronJobRun` protos instead of `ApiFlow` returned by deleted
  `ListCronJobFlows`/`GetCronJobFlow`.
- Changed `CreateCronJob` to accept newly introduced `ApiCreateCronJobArgs`
  instead of an `ApiCronJob`. `ApiCreateCronJobArgs` only allows to create
  hunt-based cron jobs.
- All `ApiFlowRequest` responses do not fill the AFF4 specific
  `request_state.request` field anymore. Similarly, the `task_id` and `payload`
  fields in `ApiFlowRequest.responses` objects is not populated anymore starting
  from this release.
- Flow log results returned by `ApiListFlowLogsHandler` do not contain the name
  of the flow the logs are for anymore.
- The `ListPendingGlobalNotifications` and `DeletePendingGlobalNotification` API
  methods have been deleted, since GRR no longer supports global notifications.
  The corresponding protos `ApiListPendingGlobalNotificationsResult` and
  `ApiDeletePendingGlobalNotificationArgs` have been deprecated.


### 3.2.3.2 (Jun 28 2018)
- This is an off-schedule release that fixes a client-repacking bug introduced
in v3.2.3.0.

### 3.2.3.0 (Jun 25 2018)
- We are planning to deprecate the SQLite datastore in favor of MySQL. Support
for SQLite will likely get dropped in the coming few releases.
- Significant progress has been made towards reimplementing GRR's database model
to use a relational schema. We expect to launch the new model - replacing the
old one - in the next few months. The new model will not have a SQLite
implementation (which is why we are dropping SQLite).
- UI improvements and bugfixes.
- Previously, when building and repacking client templates, config options in
the 'ClientBuilder' context would leak into client config files. This will no
longer happen, starting from this release. Config files that define client
options inside a 'ClientBuilder' context might need fixing.
- Api Updates:
    - `GetGrrBinary` API method now returns `ApiGrrBinary` object instead of a
    binary stream. The old behavior is preserved in a newly introduced
    `GetGrrBinaryBlob` method.
    - Additional fields were added to `Api{Hunt,CronJob,Client}Approval` protos:
    `requestor` and `email_message_id`.
    - `ApiNotification.Type` enum has been changed: 0 now means
    'UNSET' (previously it meant 'DISCOVERY', but 'DISCOVERY' type is now
    deprecated).
    - `ApiNotificationDiscoveryReference` has been renamed to
    `ApiNotificationClientReference`.
    - `ApiNotificationFileDownloadReference` has been deprecated.
    - In `ApiNotificationCronReference` and
    `ApiNotificationCronJobApprovalReference` protos, the `cron_job_urn` field
    has been replaced with `cron_job_id`.
    - In the `ApiNotificationHuntReference` proto, the `hunt_urn` field has
    been replaced with `hunt_id`.

### 3.2.2.0 (Mar 12 2018)
- As of this release, GRR's legacy asciidoc documentation (previously hosted on
github) has been deleted. <https://grr-doc.readthedocs.io> is now GRR's only
documentation repository.
- GRR's protobufs have been refactored into their own pip package
`grr-response-proto`, which is now a dependency of `grr-response-core`.
- User objects now get automatically created when using
`RemoteUserWebAuthManager`
(see [Running GRR behind Nginx](maintaining-and-tuning/user-management/running-behind-nginx.md)).
Users who log in for the first time no longer need to do anything special to
make notifications work.
- `grr-response-client`'s pip dependency for Rekall has been updated to
version `1.7.2rc1`.
- Functionality has been added to allow showing predefined warnings in the
Admin UI when accessing clients with certain labels (`AdminUI.client_warnings`
config option).
- Scanning and dumping process memory with Yara has been made more
resource-efficient, and now puts less strain on client machines.
- A number of changes have been made to the GRR Api, some of which are not
backwards compatible with Api client code expecting pre-3.2.2.0 responses
and behavior:
    - `hunt_pb2.ApiListHuntLogsResult` now uses `hunt_pb2.ApiHuntLog`, a new
    proto, instead of `jobs_pb2.Flowlog`.
    - `hunt_pb2.ApiListHuntErrorsResult` now uses `hunt_pb2.ApiHuntError`, a
    new proto, instead of `jobs_pb2.HuntError`.
    - `flow_pb2.ApiListFlowLogsResult` now uses `flow_pb2.ApiFlowLog`, a new
    proto, instead of `jobs_pb2.Flowlog`.
    - The default `age` attribute has been removed from Api responses.
    - `cron_pb2.ApiCronJob` protos now have a `cron_job_id` field.
    - `GetClientVersions` Api call (/api/clients/<client_id>/versions) no longer
    includes metadata (last ping, last clock, last boot time, last crash time).

### 3.2.1.1 (Dec 6 2017)

- The `HTTPDatastore` has been removed from GRR.
- GRR now supports MySQL out of the box (when installed from the server deb).
- GRR's documentation has been revised and moved to
<https://grr-doc.readthedocs.io>. The old asciidoc documentation (currently 
hosted on github) will be deleted before the next release.
- SSO support has been added to the Admin UI, with the
`RemoteUserWebAuthManager`.
- Auto-refresh functionality for flows and hunts has been added to the GRR UI.
- Support for per-client-average limits for hunts has been added.
- GRR now uses the pytest framework to run tests. `grr_run_tests` is deprecated,
and will be removed before the next release.
- Support for scanning and dumping process memory using Yara has been added.
- The `SearchFileContent` flow has been deprecated, in favor of equivalent
`FileFinder` functionality.
- zip/tar.gz archives downloaded from GRR will no longer use
symlinks to avoid duplication of files - this makes them easier to work with.

### 3.2.0.1 (Sep 5 2017)

Starting with 3.2.0.1, we plan on releasing more frequently, since we
have automated a large part of the release process. The recommended way
of installing this version of GRR is with the server debian package,
which includes client templates for all supported platforms. PIP
packages, and a Docker image for the release will be made available at a
later date.

  - **IMPORTANT** Before upgrading, make sure to back up your data
    store. This release has changes that may be incompatible with older
    versions of the data store. Also make copies of your configs - for
    reference, and in case you want to roll back the upgrade.

  - **WARN** Rekall is disabled by default. 'Rekall.enabled: True' line
    should be added to GRR configuration file in order for Rekall to
    work. There are known stability issues in Rekall and winpmem driver.
    Disabling it by default makes its 'in dev/experimental' status more
    explicit.

  - **WARN** Components are deprecated. The GRR client is now
    monolithic, there’s no need to upload or update components anymore.
    NOTE: The new GRR server will only be able to run Rekall-based flows
    (AnalyzeClientMemory, MemoryCollector) with the latest GRR client,
    since it expects the client not to use components.

  - **WARN** Rekall flows have been moved to 'DEBUG' category. They
    won’t be visible unless users enable 'Mode: DEBUG' in the settings
    menu (accessible via the settings button in top right corner of GRR
    AdminUI).

  - **WARN** A number of backwards-incompatible datastore schema changes
    were made. The nature of these changes is such that easy data
    migration between releases is not possible. Data loss of flows and
    hunts is possible. Please back up your current system if this data
    is critical.

  - **WARN** A number of deprecated configuration options were removed.
    If GRR fails to start after the upgrade, please check the server
    logs for 'Unknown configuration option' messages.

  - **WARN** Global Flows are no longer supported.

  - **INFO** Bugfixes, additionals tests and code health work in all
    parts of the system.

  - **INFO** HTTP API now covers 100% of GRR functionality. Python API
    client library significantly extended. API call routers implemented,
    allowing for flexible authorization.

  - **INFO** 'Download as' functionality added to flows and hunts.
    Supported formats are CSV, YAML and SQLite.

  - **INFO** Build process for clients and server is significantly
    improved. Client templates for all supported platforms, as well as a
    release-ready server deb, get built on every github commit.

### 0.3.0-7 to 3.1.0.2

Note that we shifted our version string left to reduce confusion, see
the [documentation on GRR
versions](admin.md#client-and-server-version-compatibility-and-numbering).

  - **WARN** Quite a few config options have changed. We recommend
    moving any customizations you have into your server.local.yaml, and
    using the main config file supplied with the new version. Some
    important specific ones are called out here.

  - **WARN** Config option Client.control\_urls has been replaced with
    Client.server\_urls. You will need to make sure your polling URL is
    set in the new variable.

  - **WARN** We have completely rewritten how memory collection and
    analysis works inside GRR. Rekall is now responsible for all driver
    loading, memory collection, and memory analysis. It also replaces
    the functionality of the Memory Collector flow. This means you
    **must** upgrade your clients to be able to do memory collection and
    analysis.

  - **WARN** Repacking of old client templates no longer works due to
    [changes necessary for repacking different
    versions](https://github.com/google/grr/issues/379). You will need
    to use the new client templates that include a build.yaml file.

  - **WARN** Config option Cron.enabled\_system\_jobs (a allowlist) was
    replaced with Cron.disabled\_system\_jobs (a blocklist) to make
    adding new cronjobs easier. You will need to remove
    Cron.enabled\_system\_jobs and if you made customizations here,
    translate any jobs you want to remain disabled to the new list.

  - **WARN** We changed the format for the Knowledge Base protocol
    buffer to remove a duplication of the users component which was
    storing users information twice and complicating code. This means
    that all clients need a fresh interrogate run to populate the
    machine information. Until the machines run interrogate the
    `%%users.homedir%%` and similar expansions won’t work.

  - **WARN** The compiler we use to build the Mac client template has
    become more aggressive with optimizations and now emits code
    optimized to specific processor versions. The mac client will not
    run on a processor older than our build machine - an early 2011
    Macbook with the Intel Sandy Bridge architecture. If you need to run
    GRR on, for example, Core 2 duo machines, you will need a custom
    client built on one of those machines.

  - **WARN** We [no longer support running the client on Windows
    XP](https://github.com/google/grr/issues/408), it’s difficult to
    make it work and we have no use for an XP client ourselves. See
    [here](faq.md#what-operating-system-versions-does-the-client-support)
    for our OS support statement.

  - **INFO** Strict context checking was added for config files in [this
    commit](https://github.com/google/grr/commit/56ee26d41afc5809e52d432096de8dbf09564851),
    which exposed a number of minor config typo bugs. If you get
    InvalidContextError on upgrade, you need to update your config to
    fix up the typos. The
    [config/contexts.py](https://github.com/google/grr/blob/markdown/config/contexts.py)
    file is the canonical reference.

Upgrade procedure:

1.  Make backups of important data such as your configs and your
    database.

2.  Upgrade to xenial

3.  Clear out any old installations: `sudo rm -rf /usr/local/bin/grr_*;
    sudo rm -rf /usr/local/lib/python2.7/dist-packages/grr/`

4.  Install deb package

5.  Backup then remove your /etc/grr/grr-server.yaml. Make sure any
    customizations you made are stored in `/etc/grr/server.local.yaml`.

6.  Run `grr_config_updater initialize`

### 0.3.0-6 to 0.3.0-7

  - **INFO** We moved to using the open source binplist, rather than
    bundling it with GRR. If you are getting "ImportError: cannot import
    name binplist", make sure you have installed the binplist package
    and deleted grr/parsers/binplist\* to clean up any .pyc files that
    might have been created.

  - **INFO** If you have troubles with the rekall efilter library
    failing to import, try deleting all of your rekall-related .pyc’s
    and make sure you’re installing the version in requirements.txt. See
    [this bug](https://github.com/google/grr/issues/275) for full
    details.

### 0.3.0-5 to 0.3.0-6

This version bump was to keep in step with the client, which got a new
version because of a memory collection bug.

  - **WARN** The artifact format [changed in a
    way](https://github.com/ForensicArtifacts/artifacts/pull/11) that is
    not backwards compatible. You’ll need to delete any artifacts you
    have in the artifact manager, either through the GUI or on the
    console with `aff4.FACTORY.Delete("aff4:/artifact_store")` before
    you upgrade. If you forget you should be able to use the console or
    you can roll back to [this
    commit](https://github.com/google/grr/commit/0ac377613af92f23948b829d7cf86b9b947b1e44)
    before the artifact change.

  - **WARN** Keyword search is now based on an index that is built at
    weekly interrogate time, which means decomissioned clients won’t
    appear in search results. To populate all of your historical clients
    into the search index, use the code snippet on [this
    commit](https://github.com/google/grr/commit/faa1622942e765447b6a908d8baf321e7bd288b9#commitcomment-10597659).

### 0.3.0 to 0.3.0-5

  - **WARN** Rekall made some fundamental changes that mean rekall in
    the 0.3.0-5 server won’t work with rekall in 3.0.0.3 clients, so a
    client upgrade to 3.0.0.5 is required. Non-rekall GRR components
    should continue to work.

  - **WARN** The enroller component was removed, and is now handled by
    the worker. You will need to stop those jobs and delete the relevant
    upstart/init scripts.

  - **INFO** We now check that all config options are defined in the
    code and the server won’t start if they aren’t. When you upgrade
    it’s likely there is some old config that will need cleaning up.
    See the graveyard below for advice.

### 0.2.9 to 0.3.0

  - **WARN** After install of new deb you will need to restart the
    service manually.

  - **INFO** To get the new clients you will want to repack the new
    version with `sudo grr_config_updater repack_clients`. This should
    give you new Windows, Linux and OSX clients.

  - **INFO** Client themselves will not automatically be upgraded but
    should continue to work.

### 0.2-8 to 0.2-9

  - **WARN** After install of new deb you will need to restart the
    service manually.

  - **WARN** Users have changed from being managed in the config file to
    being managed in the datastore. This means your users will not work.
    We haven’t migrated them automatically, please re-add with `sudo
    grr_config_updater
    add_user <user>`

  - **INFO** To get the new clients you will want to repack the new
    version with `sudo grr_config_updater repack_clients`. This should
    give you new Windows, Linux and OSX clients.

  - **INFO** Client themselves will not automatically be upgraded but
    should continue to work.

## Client

### 3.2.0.1 -

Starting from 3.2.0.1, we the same version string for the client and server,
since they get released at the same time.

### 3.0.7.1 to 3.1.0.0

Note that we skipped some numbers to make versioning simpler and reduce
confusion, see the [documentation on GRR
versions](admin.md#client-and-server-version-compatibility-and-numbering).

  - **WARN** We changed rekall to be a independently updatable component
    in the client, which is a backwards incompatible change. You must
    upgrade your clients to 3.1.0.0 if you want to use memory
    capabilities in the 3.1.0 server.

  - **WARN** Our previous debian package added the GRR service using
    both upstart and init.d runlevels. This caused some confusion on
    systems with ubuntu upstart systems. We detect and remove this
    problem automatically with the new version, but since it is a config
    file change you need to specify whether to install the new config or
    keep the old one, [or you will get a config change
    prompt](https://raphaelhertzog.com/2010/09/21/debian-conffile-configuration-file-managed-by-dpkg/).
    New is preferred. Something like `sudo apt-get -o
    Dpkg::Options::="--force-confnew" grr`.

### 3.0.0.7 to 3.0.7.1

  - **INFO** 3.0.7.1 is the first version of GRR that will work on OS X
    El Capitan. The new [OS X System Integrity
    Protection](https://derflounder.wordpress.com/2015/10/01/system-integrity-protection-adding-another-layer-to-apples-security-model/)
    meant we had to shift our install location from `/usr/lib/` to
    `/usr/local/lib`.

  - **INFO** We changed our version numbering scheme for the client at
    this point to give us the ability to indicate multiple client
    versions that work with a server version. So 3.0.7.\* clients will
    all work with server 0.3.0-7.

### 3.0.0.6 to 3.0.0.7

  - **WARN** Linux and OS X clients prior to 3.0.0.7 were using
    `/etc/grr/client.local.yaml` as the local writeback location. For
    3.0.0.7 this was changed to `/etc/%(Client.name).local.yaml` where
    the default is `/etc/grr.local.yaml`. If you wish to preserve the
    same client IDs you need to use platform management tools to copy
    the old config into the new location for all clients before you
    upgrade. If you don’t do this the clients will just re-enrol and get
    new client IDs automatically.

### 3.0.0.5 to 3.0.0.6

  - **INFO** 3.0.0.5 had a bug that broke memory collection, fixed in
    [this
    commit](https://github.com/google/grr/commit/0615006a740a2802c4cf6c4b6a17e776e128dc06).
    We also wrote a temporary server-side
    [workaround](https://github.com/google/grr/commit/0615006a740a2802c4cf6c4b6a17e776e128dc06#diff-3a7572dd4343868d0929cbdca7a1620cR77),
    so upgrading isn’t mandatory. 3.0.0.5 clients should still work
    fine.

### 3.0.0.3 to 3.0.0.5

(We skipped a version number, there’s no 3.0.0.4)

### 3.0.0.2 to 3.0.0.3

  - **WARN** A change to OpenSSL required us to sign our CSRs generated
    during the enrollment process. This wasn’t necessary previously and
    provided no benefit for GRR so we had gained some speed by not doing
    it. Since new OpenSSL required it, we started signing the CSRs, but
    it meant that the 3.0.0.3 server will reject any 3.0.0.2 clients
    that haven’t already enrolled (i.e. they will see a HTTP 406). Old
    3.0.0.2 clients that have already enrolled and new 3.0.0.3 clients
    will work fine. This basically just means that you need to push out
    new clients at the same time as you upgrade the server.

## Config Variable Graveyard

Sometimes config variables get renamed, sometimes removed. When this
happens we’ll try to record it here, so users know if local settings
should be migrated/ignored etc.

You can verify your config with this (root is required to read the
writeback
    config)

    sudo PYTHONPATH=. python ./run_tests.py --test=BuildConfigTests.testAllConfigs

  - AdminUI.team\_name: replaced by Email.signature

  - ClientBuilder.build\_src\_dir: unused, effectively duplicated
    ClientBuilder.source

  - ClientBuilder.executables\_path: ClientBuilder.executables\_dir

  - Client.config: unused. Now built from Client.config\_hive and
    Client.config\_key

  - Client.config\_file\_name: unused

  - Client.location: replaced by Client.control\_urls

  - Client.package\_maker\_organization: replaced by
    ClientBuilder.package\_maker\_organization

  - Client.tempdir: replaced by Client.grr\_tempdir and
    Client.tempdir\_roots

  - Email.default\_domain: essentially duplicated Logging.domain, use
    that instead.

  - Frontend.processes: unused

  - Nanny.nanny\_binary: replaced by Nanny.binary

  - NannyWindows.\* : replaced by Nanny.

  - PyInstaller.build\_root\_dir: unused, effectively duplicated
    ClientBuilder.build\_root\_dir.

  - Users.authentication: unused, user auth is now based on aff4:/users
    objects. Use config\_updater to modify them.

  - Worker.task\_limit: unused

  - Worker.worker\_process\_count: unused

  - Cron.enabled\_system\_jobs (a allowlist) was replaced with
    Cron.disabled\_system\_jobs (a blocklist).
    Cron.enabled\_system\_jobs should be removed. Any custom jobs you
    want to stay disabled should be added to Cron.enabled\_system\_jobs.

  - Client.control\_urls: renamed to Client.server\_urls.
