# encoding: utf-8
# frozen_string_literal: true

# Copyright 2016, Patrick Muench
# Copyright 2017, Christoph Hartmann
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# author: Christoph Hartmann
# author: Dominik Richter
# author: Patrick Muench

title 'Container Images and Build File'

# attributes
CONTAINER_USER = attribute('container_user')

# check if docker exists
only_if('docker not found') do
  command('docker').exist?
end

control 'docker-3.15' do
  impact 1.0
  title 'Verify that Docker socket file ownership is set to root:docker'
  desc 'Verify that the Docker socket file is owned by \'root\' and group-owned by \'docker\'.
  Rationale: Docker daemon runs as \'root\'. The default Unix socket hence must be owned by \'root\'. If any other user or process owns this socket, then it might be possible for that non-privileged user or process to interact with Docker daemon. Also, such a non-privileged user or process might interact with containers. This is neither secure nor desired behavior. Additionally, the Docker installer creates a Unix group called \'docker\'. You can add users to this group, and then those users would be able to read and write to default Docker Unix socket. The membership to the \'docker\' group is tightly controlled by the system administrator. If any other group owns this socket, then it might be possible for members of that group to interact with Docker daemon. Also, such a group might not be as tightly controlled as the \'docker\' group. This is neither secure nor desired behavior. Hence, the default Docker Unix socket file must be owned by \'root\' and group-owned by \'docker\' to maintain the integrity of the socket file.'

  tag 'docker'
  tag 'cis-docker-1.12.0': '3.15'
  tag 'cis-docker-1.13.0': '3.15'
  tag 'level:1'
  ref 'Use the Docker command line', url: 'https://docs.docker.com/engine/reference/commandline/cli/#daemon-socket-option'
  ref 'Protect the Docker daemon socket', url: 'https://docs.docker.com/engine/security/https/'

  describe file('/var/run/docker.sock') do
    it { should exist }
    it { should be_socket }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'docker' }
  end
end
