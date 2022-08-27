Vagrant.configure("2") do | config |
    config.vm.define "dbserver" do | db |
        db.vm.box= "ubuntu/focal64"
        db.vm.network "private_network", ip: "192.168.10.10", virtualbox__intnet:"rconnect_network"
        db.vm.provision "shell", path:"provisioners/sh/install-mysql.sh"
        db.vm.provider "virtualbox" do | vm1 |
            vm1.cpus = 2
            vm1.memory = 2048
            vm1.name = "ubuntu_dbserver"
        end
    end

    config.vm.define "javaserver" do | javaapp |
        javaapp.vm.box = "ubuntu/focal64"
        javaapp.vm.network "forwarded_port", guest: 8080, host: 8081
        javaapp.vm.network "private_network", ip: "192.168.10.11", virtualbox__intnet:"rconnect_network"
        javaapp.vm.provision "shell", path:"provisioners/sh/install-tomcat.sh"
        javaapp.vm.provider "virtualbox" do | vm2 |
            vm2.cpus = 2
            vm2.memory = 2048
            vm2.name = "ubuntu_javaserver"
        end
    end
end