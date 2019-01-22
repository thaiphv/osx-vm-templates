= Build MacOS X Vagrant boxes using Packer
The purpose of this task is to create reproducible MacOS instances when we need them. However, since MacOS X virtualization especially on provider like VirtualBox, the process can not be fully automatic. By using Vagrant to bootstrap the instance, we can keep track of changes to the configuration of the VM, which are documented in `Vagrantfile` files.
Requirements:
1. MacOS hardware. This can be any decent machines that can be upgraded to the latest MacOS X version, depending on the need.
2. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
3. [Packer](https://www.packer.io/)
4. [Vagrant](https://www.vagrantup.com/)
5. [Packer templates and ISO file build scripts](https://github.com/timsutton/osx-vm-templates)
6. `git`

== Build a VirtualBox VDI image
The steps below are applicable to MacOS X 10.13 (High Sierra). Things can be changed slightly on newer versions and the docs should be updated accordingly. See [documentation](https://github.com/thaiphv/osx-vm-templates#alternative-method-using-prepare_vdish-prepare_ovfsh-and-packer-virtualbox-ovf) for more detail.
1. On the host MacOS machine, open AppStore and search for `High Sierra` and hit on the `Download` button.
2. Once the installer app has been downloaded successfully, quit the app after it has been launched.
3. Open a terminal, checkout [this repo](https://git.freelancer.com/tpham/osx-vm-templates.git)
```bash
$ git clone https://git.freelancer.com/tpham/osx-vm-templates.git
$ cd osx-vm-templates && cd packer
$ sudo ../prepare_iso/prepare_vdi.sh \
  -D DISABLE_REMOTE_MANAGEMENT \
  -D DISABLE_SCREEN_SHARING \
  -D DISABLE_SIP \
  -s 100 \
  -u vagrant
  -p <redacted>
  -o macOS_10.13.vdi \
   /Applications/Install\ macOS\ High\ Sierra.app/ \
  .
$ ../prepare_iso/prepare_ovf.sh macOS_10.13.vdi
```

== Build a Vagrant box using Packer
```bash
$ packer build --only virtualbox-ovf -var provisioning_delay=30 -var source_path=macOS_10.13.ovf -var username=vagrant -var password=<redacted> -var output_directory="./" -var vagrant_box_directory="./" template.json
```
The built box can be uploaded to an S3 bucket and shared across different offices.

== Import the Vagrant box
```bash
$ vagrant box add --name macos_10_13 <path_to_the_box_file>
```

== TODO
1. Set up a self-hosted vagrant cloud
2. Version the boxes
