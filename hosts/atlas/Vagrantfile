# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
  end

  config.vm.box = "ubuntu/bionic64"

  config.vm.synced_folder ".", "/vagrant/atlas"
  config.ssh.extra_args = ["-t", "cd /vagrant/atlas; bash --login"]

  config.vm.disk :disk, size: "20GB", primary: true

  config.vm.provision :docker

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update -y && apt-get install make sqlite3 -y
    cd /vagrant/atlas && make start
  SHELL

  config.vm.hostname = "atlas"

  supported_programs = %w(gitea jellyfin tinymediamanager portainer flame)
  environment = "development"

  atlas = AtlasBuilder.new(supported_programs, environment)

  supported_programs.each do |supported_program|
    host_ip = atlas.use_host_ip(supported_program) ? "127.0.0.1" : nil

    atlas.get_ports(supported_program).each do |name, port|
      config.vm.network "forwarded_port",
        guest: port,
        host: port,
        host_ip: host_ip,
        id: name.downcase
    end
  end
end

class AtlasBuilder
  def initialize(supported_programs, environment)
    raw_environment_variables = File.open(".env.#{environment}").read.split("\n")
      .map { |data| data.split("=") }
      .to_h

    @environment_variables = Hash.new

    raw_environment_variables.each do |key, value|
      terms = key.split("_")

      if terms.count() > 1
        program = terms[0].downcase

        if supported_programs.include? program
          @environment_variables[program] = raw_environment_variables.select do |key, value|
            key.include? program.upcase
          end
        else
          @environment_variables[key] = value
        end
      else
        @environment_variables[key] = value
      end
    end
  end

  def add_environment_variable(key, value)
    @environment_variables[key] = value
  end

  def get_ports(program)
    @environment_variables[program].select { |key, value| key.include? "_PORT" }
  end

  def use_host_ip(program)
    begin
      @environment_variables[program]["#{program.upcase}_USE_NETWORK_HOST"] == "true"
    rescue
      false
    end
  end
end
