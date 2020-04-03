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

title 'Docker Daemon Configuration Files'

# attributes
REGISTRY_CERT_PATH = attribute('registry_cert_path')
REGISTRY_NAME = attribute('registry_name')
REGISTRY_CA_FILE = attribute('registry_ca_file')

# check if docker exists
only_if('docker not found') do
  command('docker').exist?
end

control 'docker-3.2' do
  impact 1.0
  title 'Verify that docker.service file permissions are set to 644 or more restrictive'
  desc 'Verify that the \'docker.service\' file permissions are correctly set to \'644\' or more restrictive.

  Rationale: \'docker.service\' file contains sensitive parameters that may alter the behavior of Docker daemon. Hence, it should not be writable by any other user other than \'root\' to maintain the integrity of the file.'

  tag 'docker'
  tag 'cis-docker-1.12.0': '3.2'
  tag 'cis-docker-1.13.0': '3.2'
  tag 'level:1'
  ref 'Control and configure Docker with systemd', url: 'https://docs.docker.com/engine/admin/systemd/'

  describe file(docker_helper.path) do
    it { should_not be_writable.by('other') }
    it { should_not be_executable }
  end
end


