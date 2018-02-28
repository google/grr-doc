# Installing from a HEAD DEB

Instructions for installing the latest stable version of GRR can be found
[here](from-release-deb.md). If you would like to experiment with the
newest unstable server deb, you can download it from Google Cloud Storage
as follows:


* Download the latest Google Cloud SDK tarball from <https://cloud.google.com/sdk/downloads>, e.g:

```bash
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-180.0.1-linux-x86_64.tar.gz
```

* Extract it to somewhere on your filesystem:

```bash
tar zxf google-cloud-sdk-180.0.1-linux-x86_64.tar.gz -C "${HOME}"
```

* Copy the server deb from its folder in GCS to your local machine:

```bash
$HOME/google-cloud-sdk/bin/gsutil cp gs://autobuilds.grr-response.com/_latest_server_deb/*.deb .
```
