# Copyright 2023 Google LLC
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
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
  git \
  python3-pip \
  python-is-python3 \
  python3.10-venv \
  python3-yaml \
  pkg-config \
  libmysqlclient-dev \
  openjdk-19-jre

WORKDIR /

RUN cd / && git clone https://github.com/google/grr

RUN cd /grr/ \
  && python -m venv --system-site-packages venv \
  && . venv/bin/activate \
  && pip install mysqlclient nodeenv wheel \
  && nodeenv -p --prebuilt --node=16.13.0

RUN cd /grr \
  && . /grr/venv/bin/activate \
  && pip install -e grr/proto \
  && pip install -e grr/core \
  && pip install -e grr/client \
  && pip install -e grr/client_builder \
  && pip install -e api_client/python \
  && pip install -e grr/server
