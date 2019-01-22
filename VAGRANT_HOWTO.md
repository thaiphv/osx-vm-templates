= How to use the VM defined by the `Vagrantfile` file

The VMs are configured based on the MAC address allocation in T44436#852861. Simply
run `vagrant up <office_name>-<instance_id>` in order to bring up a VM. We can probably
configure all the MacOS slaves in the Jenkins master in advance so that it will automatically
connect to any of them whenever they are up and running.

We should also declare the environment variables that define the username of password of the user
which will be used by the Jenkins master to SSH to the CI slaves.
```bash
JENKINS_USERNAME=jenkins JENKINS_PASSWORD=<redacted> vagrant up <office_name>-<instance_id>
```

After the guest instances have been provisioned, we can restart them so that the auto login
setting takes effect.
```bash
vagrant halt <office_name>-<instance_id>
vagrant up <office_name>-<instance_id>
```
