VAGRANT_VM_COUNT = 3
VAGRANT_BOX = "centos/7"
VAGRANT_MEMORY = 1024
VAGRANT_CPUS = 2
VAGRANT_NETWORK_PREFIX = "192.168.56."

Vagrant.configure("2") do |config|
  (1..VAGRANT_VM_COUNT).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.box = VAGRANT_BOX
      node.vm.hostname = "node#{i}"
      node.vm.network "private_network", ip: "#{VAGRANT_NETWORK_PREFIX}#{100 + i}"

      node.vm.provider "virtualbox" do |vb|
        vb.name = "node#{i}"
        vb.memory = VAGRANT_MEMORY
        vb.cpus = VAGRANT_CPUS
      end

      # Додаткові параметри (наприклад, синхронізація папки, provisioners тощо)
      # node.vm.synced_folder "./shared", "/vagrant_data"
    end
  end
end
