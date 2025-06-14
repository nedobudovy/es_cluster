VAGRANT_VM_COUNT = 1 # Change it to 3 for prod, please... Don't forget it :)
VAGRANT_BOX = "rockylinux/9"
VAGRANT_MEMORY = 4096
VAGRANT_CPUS = 2
VAGRANT_NETWORK_PREFIX = "192.168.56."

Vagrant.configure("2") do |config|
  (1..VAGRANT_VM_COUNT).each do |i|
    #Basic configuration of each node
    config.vm.define "es_node#{i}" do |node|
      node.vm.box = VAGRANT_BOX
      node.vm.hostname = "es-node#{i}"

      node.vm.network "private_network", ip: "#{VAGRANT_NETWORK_PREFIX}#{100 + i}"

      node.vm.provider "virtualbox" do |vb|
        vb.name = "node#{i}"
        vb.memory = VAGRANT_MEMORY
        vb.cpus = VAGRANT_CPUS
      end

      node.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines(File.expand_path("~/.ssh/es_cluster.pub")).first.strip
        s.inline = <<-SHELL
          echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
          echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
        SHELL
      end
      

      node.vm.provision "shell", inline: <<-SHELL
        #sudo dnf update -y
        sudo dnf -y install epel-release
        sudo dnf -y install ansible
      SHELL
    end

    config.vm.define "kibana" do |node|
      node.vm.box = VAGRANT_BOX
      node.vm.hostname = "kibana"

      node.vm.network "private_network", ip: "#{VAGRANT_NETWORK_PREFIX}99"
      node.vm.network "forwarded_port", guest: 5601, host: 5601

      node.vm.provider "virtualbox" do |vb|
        vb.name = "kibana"
        vb.memory = VAGRANT_MEMORY
        vb.cpus = VAGRANT_CPUS
      end

      node.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines(File.expand_path("~/.ssh/es_cluster.pub")).first.strip
        s.inline = <<-SHELL
          echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
          echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
        SHELL
      end

      node.vm.provision "shell", inline: <<-SHELL
        #sudo dnf update -y
        sudo dnf -y install epel-release
        sudo dnf -y install ansible
      SHELL
    end

    config.vm.define "nginx" do |node|
      node.vm.box = VAGRANT_BOX
      node.vm.hostname = "nginx-proxy"

      node.vm.network "private_network", ip: "#{VAGRANT_NETWORK_PREFIX}98"
      node.vm.network "forwarded_port", guest: 80, host: 8080
      node.vm.network "forwarded_port", guest: 443, host: 8443

      node.vm.provider "virtualbox" do |vb|
        vb.name = "nginx-proxy"
        vb.memory = 2048
        vb.cpus = 1
      end

      node.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines(File.expand_path("~/.ssh/es_cluster.pub")).first.strip
        s.inline = <<-SHELL
          echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
          echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
        SHELL
      end

      node.vm.provision "shell", inline: <<-SHELL
        #sudo dnf update -y
        sudo dnf -y install epel-release
        sudo dnf -y install ansible
      SHELL
    end
  end
end
