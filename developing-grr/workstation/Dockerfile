# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM  europe-west1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN wget https://github.com/googlecodelabs/tools/releases/download/v2.2.6/claat-linux-amd64 && \
    mv claat-linux-amd64 /usr/local/bin/claat && \
    chmod 755 /usr/local/bin/claat

RUN mkdir -p /var/src && \
    cd /var/src && \
    git clone https://github.com/google/grr.git && \
    git config --global --add safe.directory /var/src/grr && \
    git clone https://github.com/google/grr-doc.git && \
    git config --global --add safe.directory /var/src/grr-doc

COPY ./workstation_startup_d/011_mount_filestore.sh /etc/workstation-startup.d/
RUN chmod +x /etc/workstation-startup.d/011_mount_filestore.sh

COPY ./workstation_startup_d/200_install-demo.sh /etc/workstation-startup.d/
RUN chmod +x /etc/workstation-startup.d/200_install-demo.sh

COPY ./settings.json /demo/
COPY ./workstation_startup_d/250_default-ide-color-theme.sh /etc/workstation-startup.d/
RUN chmod +x /etc/workstation-startup.d/250_default-ide-color-theme.sh
