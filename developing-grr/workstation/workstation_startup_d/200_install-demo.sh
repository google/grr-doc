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
#!/bin/bash
# shellcheck disable=SC1091
export USER=user
BASE=$(pwd)
export BASE
export LC_ALL=C.UTF-8
echo "-----------------"
echo "Waiting for Docker to start"
while (! docker stats --no-stream ); do
  # Docker takes a few seconds to initialize
  echo "Waiting for Docker to launch..."
  sleep 1
done
echo "-----------------"
echo "Synchronising repos..."
if [ ! -f /home/user/src/grr/README.md ]; then
  cp -R /var/src /home/user/src
  chown -R user:user /home/user/src
  git config --global --add safe.directory /home/user/src/grr
  git config --global --add safe.directory /home/user/src/grr-doc
fi
echo "-----------------"
echo "Pulling grr..."
cd /home/user/src/grr/
git pull
echo "-----------------"
echo "Pulling grr-doc..."
cd /home/user/src/grr-doc/
git pull
echo "-----------------"
echo "Starting claat..."
cd /home/user/src/grr-doc/developing-grr/codelabs
claat export how-to-add-a-client-action.md
claat export how-to-add-a-flow.md
claat serve -addr 0.0.0.0:9090 &
echo "-----------------"
cd "$BASE" || exit
echo "demo installation done"
echo "-----------------"
