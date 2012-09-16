# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  # Use this basebox image
  config.vm.box = "centos_6_x86_64_minimal_4.1.12"
  # If the basebox image is not yet cached on the local system source it from here
  config.vm.box_url = "https://dl.dropbox.com/u/5861161/vagrant/CentOS-6.0-x86_64-netboot-4.1.12.box"

  # CFEngine really doens't require much in the way of resources
  config.vm.customize ["modifyvm", :id, "--memory", 256]

  # Use this for debugging or getting a better visual picture of whats
  # happening. There may be some bugs related to gui mode that may or
  # may not have anything to do with the CFEngine provider.
  config.vm.boot_mode = :gui

	config.vm.provision  :puppet


  # Policy Hub Definition
  config.vm.define :xymond do |host_config|
    # Hostname to set on the node
    host_config.vm.host_name="xymond"

    # Hostonly network interface, used for internode communication
    host_config.vm.network :hostonly, "10.1.1.10"

  end

end
