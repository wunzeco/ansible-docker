require 'spec_helper'

docker_allow_users = [ 'ogonna' ]
docker_swarm_image_version = '1.2.0'

%w(
  apt-transport-https
  apparmor
  ca-certificates
  python-pip
  docker-engine
).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe package('lxc-docker') do
  it { should_not be_installed }
end

# ensure docker-compose binary is available
describe command('docker-compose -h') do
    its(:exit_status) { should eq 0 }
end

describe file('/etc/init.d/docker') do
  it { should_not exist }
end

describe file('/etc/default/docker') do
  it { should be_file }
  it { should be_mode 644 }
end

docker_allow_users.each do |u|
  describe user(u) do
    it { should belong_to_group 'docker' }
  end
end

describe docker_container('swarm-manager') do
  it { should be_running }
end

describe docker_image("swarm:#{docker_swarm_image_version}") do
  it { should exist }
end
