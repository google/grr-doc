***Note on the AFF4 datastore deprecation***

*Starting from the version ***3.3.0.0*** GRR uses a new datastore format by default - ***REL_DB***. REL_DB is backwards-incompatible with the now-deprecated AFF4 datastore format (even though they both use MySQL as a backend).*

*Use of AFF4-based deployments is now discouraged. REL_DB is expected to be much more stable and performant. Please see [these docs](../maintaining-and-tuning/grr-datastore.md) if you're upgrading an older GRR version and would like to try out the new datastore.*

# Installing from a HEAD DEB

1. If the Google Cloud SDK is not already installed, download a tarball for
the latest version from
<https://cloud.google.com/sdk/docs/downloads-versioned-archives>
and extract it to somewhere on your filesystem, e.g:

    ```bash
    wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-180.0.1-linux-x86_64.tar.gz

    tar zxf google-cloud-sdk-180.0.1-linux-x86_64.tar.gz -C "${HOME}"
    ```

    Alternatively, you can install the SDK using `apt-get` as described in
    <https://cloud.google.com/sdk/docs/downloads-apt-get>.

2. Use `gsutil` to copy the server deb from its GCS bucket to your local
machine:

    ```bash
    $HOME/google-cloud-sdk/bin/gsutil cp gs://autobuilds.grr-response.com/_latest_server_deb/*.deb .
    ```

3. Install the server deb the same way you would a
[release deb](from-release-deb.md).
