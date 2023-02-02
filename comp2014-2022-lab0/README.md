# comp2014-2022-lab0

COMP2014 distributed systems lab0, version 1.1, 2023-01-23.

Chris Greenhalgh, (c) The University of Nottingham, 2023.

The aim of this exercise is to check that you have VS Code and 
DevContainers working OK for Java networking applications.

Note, this is a gradle project with one simple applications, `app`, 
with main class `comp2014.lab0.App`, which is a trivial HTTP server
based on the built-in `com.sun.net.httpserver` package.

Following the usual gradle/Java organisation the source files are in `app/src/main/java`.
The default test has been removed.

## Pre-requisites

Of course you can just build and run it anyway, but the point of this is to
try out container-based development and its support in VSCode.

This requires:
- [VSCode](https://code.visualstudio.com/download)
  - [Remote-SSH extension](https://code.visualstudio.com/docs/remote/ssh) (which is included in...)
  - and optionally [Remote Development extension](https://code.visualstudio.com/docs/remote/remote-overview) (Note, only if version is Jan 2023 or later, e.g. on your own machine)
- Docker, either
  - [Docker desktop](https://www.docker.com/products/docker-desktop/) installed on your own machine,
  - [Docker engine](https://docs.docker.com/engine/install/ubuntu/) pre-installed on the COMP2014 Azure Lab VMs, or
  - [Docker engine](https://docs.docker.com/engine/install/ubuntu/) on your own VM (desktop or remote) - see instructions at end

(Otherwise you'd need at least a JDK installed on your machine, 
and hope it was the right version, etc.)

## Instructions

Note, Dev Containers works OK for me with a current (Jan 2023) version of Visual Studio Code
and Dev Containers, but doesn't current work on the CS Windows Virtual Desktop version of VS Code, 
with Remote Development extension version 0.245.2. 

If Dev Containers works then it may give a more tightly integrated code development environment, especially for web server projects. It's a bit more awkward for client-server projects, 
especially if using a remote development machine (rather than Docker desktop). 

As a reasonably universal alternative there's a regular Docker-only version of the lab.

Note that there can also be problems if you switch between Dev Containers and Docker 
for working on the same project on the same machine/checkout - see the FAQ in the Lab 0
handout.

### Docker only (not VSCode Dev Container)

Steps:
- If using a remote VM (instead of local Docker) then 
  - connect to it using VSCode command "Remote-SSH Connect to host" (add host as required).
- Check out this repo
- In VSCode open this folder
- In VSCode open a terminal and cd into this folder
- Build the docker dev image*,
```
(cd docker; docker build --tag devjdk17 .)
```
- Start a (temporary) container, mount the local files and expose the server port (leave it running...)
```
docker run -it --rm --name javadev -v $(pwd):/home/gradle/project -p 8000:8000 devjdk17
```
- Optionally, open a new Terminal and enter the same container, or use the above terminal session,
```
docker exec -it javadev /bin/bash
```
- And in the running container, build using gradle, `gradle build`
- And run the server, `gradle run` - it should print "Running port 8000, path /test"
- If using a remote VM then
  - In the PORTS tabs (next to Terminal) or View > Command Pallette... choose "Forward a Port"
  - Enter port number 8000
- Open the server URL in a browser, `http://localhost:8000/test` - it should say "This is the response"

Well done, you've built and run a Java server within a Docker container,
you explicitly exposed the port (8000, in docker run) 
(and forwarded it from the local machine if required), 
and you've connected to it from your desktop browser.

To terminate the container exit (Ctl-D) the `docker run...` session.

Note * you can also build and run the dev container using 
```
docker compose up
```
which uses the configuration in `docker-compose.yml`.
But note that the running container's name (needed for `docker exec ...`)
will be the directory name plus `-app-1`.

### VSCode Dev Container

Steps:
- If using a remote VM (instead of local Docker) then 
  - connect to it using VSCode command "Remote-SSH Connect to host" (add host as required).
- Check out this repo
- In VSCode open this folder
- Then in VSCode command "Dev Containers: Reopen in Container" - wait for container to build/start.
- In VSCode open a terminal - it should be in the container
- Build using gradle, `gradle build`
- Run the server, `gradle run`
- Check that the server port 8000 has been forwarded
- Open the server URL in a browser, `http://localhost:8000/test` - it should say "This is the response"

Well done, you've built and run a Java server within a Docker container,
VS Code has automatically exposed the port (8000), and you've connected to
it from your desktop browser.

## More details

See `docker/Dockerfile` and `.devcontainer/devcontainer.json` for the configurations of the 
dev containers.
The first is regular Docker, and uses a gradle image based on openjdk 17.
The second is VSCode dev container configuration; 
it's just the standard VSCode Java one with gradle for initial setup and curl just in case.

## VM/Docker setup

If you want to use a VM rather than Docker desktop then this covers setup for Ubuntu 20.04
(which happens to be the latest version supported at the moment in Azure Labs).

Create a VM with a Ubuntu server 20.04 base image. 

### Local VM

If you are doing this on a development laptop/desktop then
I suggest you use [Vagrant](https://developer.hashicorp.com/vagrant)
to make creating the virtual machine easy and reproducible.

You'll also need a supported VM ["provider"](https://developer.hashicorp.com/vagrant/docs/providers) 
such as [VirtualBox](https://www.virtualbox.org/).
(But note that VirtualBox may not work well or at all with Hyper-V on Windows, 
which is used by Docker Desktop for Windows, 
or with Apple Silicon - M1/M2 - on MacOS.)

The example [Vagrantfile](Vagrantfile) assumes virtual box as the provider.

Create and start the VM: in a terminal in this directory,
```
vagrant up
```
Check that you can log into the VM,
```
vagrant ssh
```

Vagrant creates and installs an SSH key to log into the new VM.
To access it from VSCode Remote-SSH,
```
cp .vagrant/machines/default/virtualbox/private_key ~/.ssh/comp2014_vm_key
```
and edit `~/.ssh/config` adding,
```
Host comp2014_vm
  User vagrant
  HostName localhost
  Port 2222
  StrictHostKeyChecking no
  IdentityFile ~/.ssh/comp2014_vm_key
  UserKnownHostsFile /dev/null
```

You should now be able to the new VM from VSCode 
using VSCode command "Remote-SSH Connect to host" and choosing "comp2014_vm".
Accept the host fingerprint if prompted.

Now move onto setting it up, below.

Note, if you are using vagrant then the host machine directory should be
mounted into the VM as `/vagrant/`, so you can use the same files, or 
clone a new copy into (say) `/home/vagrant`.

### Remote VM

Make the VM in whichever cloud provider you prefer. 
For consistency consider using a basic Ubuntu 20.04 LTS server base image.

Once it is created and running connect to it from VSCode
using VSCode command "Remote-SSH Connect to host" and adding it
(you need the full SSH command used to access the VM).

### VM Setup

On the new VM, you will need to do a one-time set-up to 
[install docker](https://docs.docker.com/engine/install/ubuntu/), 
and ensure that wget, curl and git are installed,
```
./ubuntusetup.sh
```

Also check if SSH TCP port forwarding is enabled,
```
sudo sed -i 's/^.*AllowTcpForwarding.*$/AllowTcpForwarding yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh.service
```

You may need to restart the VM for the docker group membership to take effect.
```
groups
```

