# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos/7"

#  config.ssh.private_key_path = '~/.ssh/id_rsa'
  config.ssh.forward_agent = true

  config.vm.provision "shell" do |s|
    ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
    s.inline = <<-SHELL
      mkdir -p /home/vagrant/.ssh/
      mkdir -p /root/.ssh/
      echo "#{ssh_pub_key}" >> /home/vagrant/.ssh/authorized_keys
      echo "#{ssh_pub_key}" >> /root/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/authorized_keys
      chmod 600 /root/.ssh/authorized_keys
    SHELL
  end

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "data", "/vagrant_data"

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell" do |s|
      s.inline = <<-SHELL

      # Install wget
      sudo yum -y install wget

      # Install git 1.9 from Software Collections
      sudo ./sync/installgit19.sh
      sudo ln -s /opt/rh/git19/root/usr/bin/git /usr/bin/git

      # Add the github.com public ssh key so that automated github
      # interactions over ssh work correctly in the VM.
      touch ~/.ssh/known_hosts
      if ! grep -q '^github.com ' ~/.ssh/known_hosts; then
          ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null;
      fi

      # Run bootsteap script
      ./sync/bootstrap.sh

      SHELL
  end

end
