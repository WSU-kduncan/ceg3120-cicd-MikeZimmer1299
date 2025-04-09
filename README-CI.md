# Overview
- 
# How to Set Up Docker
- Installing Docker
	- When using MacOS, you are able to go to [Docker Desktop](https://www.docker.com/products/docker-desktop/) and download it.
	- Installing Node.js use: `docker pull node:18-bullseye`
	- As an easy check to see if your Docker is able to run a container:
		- Run the command `docker pull hello-world`
		- Run the command `docker run hello-world` to check that your container can successful run. The output will be: "Hello from Docker!"
- Configuring a container
	- As of right now, I am running into issues running my command in one line, so it is broken up into two sections: in terminal and in the container
	- In Terminal Command:
		- `Docker run -it -p 5002:4200 -v ~/ceg3120-cicd-MikeZimmer1299/angular-site/wsu-hw-ng-main/.:/tempApp/ -w /tempApp node:18-bullseye sh`
			- `-it` is the combined flags `-i` and `-t`, which stats an interactive shell in the container
			- `-p` publishes a container's port (or ports) to the host
				- In this case, `5002` is on the host machine, and `4200` is the default port for the Angular app
			- `-v` bind mounts a volume
				- In this case, it binds the file contents inside `~/ceg3120-cicd-MikeZimmer1299/angular-site/wsu-hw-ng-main/.` to `/tempApp` within the container
			- `-w` Changes the working directory inside the container
				- In this case, it changes the directory to the newly created `/tempApp`
			- 
	- In Container Command:
		- `npm install -g @angular/cli && ng serve --host 0.0.0.0`
			- `npm` is the "node package manager"
			- `-g` allows the CLI to install a package globally
			- `@angular/cli` is the CLI that allows you to interact with Angular
			- `ng serve` launches the server, watches files, and rebuilds the app when changes are made
			- `--host 0.0.0.0` sets the default HTTP port 
# How to Use Docker
- Useful Tip:
	- To stop a container: `docker stop *NAMES*`, with NAME denoting the name of the container

# Useful Tips I've Learned Along the Way
- When look at the `XXXX:XXXX`, the first is your machine and second is the docker container
	- When creating new containers, the port being used for your machine must be different from other images, such as if 5000 exists, you must make a change to 5001
- For my machine, I am unable to run an overloaded command to set up the container and install the `angular/cli` and `ng serve`. They must be done in two steps currently (as explained above in "Configuring a container")

# Resources Found
- [Help Understanding "sh -c" in Docker commands](https://docs.docker.com/reference/cli/docker/container/exec/)
	- Explains `-w`/ `--workdir`
- [Running Containers Info](https://docs.docker.com/engine/containers/run/)
	- It has many good explanations for the different flags 
- [Bind Mounts](https://docs.docker.com/engine/storage/bind-mounts/)
	- Explains the ways to bind mounts. In my case, it gave explanation to `-v` for volume options