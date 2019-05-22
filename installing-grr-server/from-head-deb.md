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
