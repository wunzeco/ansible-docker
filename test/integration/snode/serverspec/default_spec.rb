require '/tmp/kitchen/spec/spec_helper.rb'

docker_allow_users = [ 'ogonna' ]
docker_swarm_image_version = '1.2.8'
smanager_ip = "172.29.129.184"
snode_ip    = "172.29.129.185"

# set PATH for docker in bash, but not in the test's env
set :path, '/usr/local/bin:$PATH'

if os[:family] == 'ubuntu'
  %w(
    python-pip
    docker-ce
  ).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

if os[:family] == 'redhat'
  %w(
    python2-pip
    docker-ce
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

describe docker_container('swarm-node') do
  it { should be_running }
end

describe docker_image("swarm:#{docker_swarm_image_version}") do
  it { should exist }
end

# query swarm cluster info from swarm-node and verify swarm-node is a member
describe command("docker -H #{smanager_ip}:3375 info") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match %r(snode.* #{snode_ip}:2375) }
end
