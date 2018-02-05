require 'spec_helper'

docker_allow_users = [ 'ogonna' ]
docker_swarm_image_version = '1.2.8'

# set PATH for docker in bash, but not in the test's env
set :path, '/usr/local/bin:$PATH'

if os[:family] == 'ubuntu'
  %w(
    python-pip
    docker-engine
  ).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

if os[:family] == 'redhat'
  %w(
    python2-pip
    docker-engine
  ).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

if os[:family] == 'ubuntu'
  %w(
    apt-transport-https
    apparmor
    ca-certificates
  ).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  describe package('lxc-docker') do
    it { should_not be_installed }
  end

  describe file('/etc/init.d/docker') do
    it { should_not exist }
  end

  docker_startup_config_file = '/etc/default/docker'
  if os[:release] == '16.04'
    docker_startup_config_file = '/etc/systemd/system/docker.service.d/docker.conf'
  end

  describe file(docker_startup_config_file ) do
    it { should be_file }
    it { should be_mode 644 }
  end

end

if os[:family] == 'redhat'

  describe package('epel-release') do
    it { should be_installed }
  end

  describe file('/etc/systemd/system/docker.service.d/docker.conf') do
    it { should be_file }
    it { should be_mode 644 }
  end

end

describe file('/etc/logrotate.d/docker-container-logs') do
  it { should be_file }
  it { should be_mode 644 }
end

# ensure docker-compose binary is available
describe command('docker-compose -h') do
    its(:exit_status) { should eq 0 }
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
