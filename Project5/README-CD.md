# Overview
- What I learned in boating school is ...
# Diagram

## Basic Tag Usage Explained
- In the repository above where files are shown, there are `main`, `branch`, and `tag`. Click on `tag` to view your tags
  - You may also use the command `git tag` to view your tags from terminal
- To generate a tag, run the command `git tag -a vX.X.X`
- To push a newly created tag, run the command `git push [branch] vX.X.X`
- **The Workflow**
  - The workflow currently pushes an Angular image to Docker Hub.
  - Current Steps:
      - It will run the workflow on `git push` to main branch with a tag
      - Its job is to build and push to Docker Hub. It will run `docker/metadata-action@v5` for pushing multiple images to Docker Hub with `:latest`, `x`, and `x.x`. It will log into Docker Hub profile, set up `QEMU` to allow multiple platform builds, build for `amd64` and `arm64`. Finally, it will push the image to Docker Hub
  - **Changes to workflow**
      - The major change to the workflow was the use of `docker/metadata-action@v5`. This allows me to add different tags to images, such as `type=semver, pattern={{major}}`.
      - I also added `${{ steps.meta.outputs.tags }}` to the tags below the `build-push-action@v6`
      - Due to my workflow being in the main folder of the repo, I did not have to change any context
  - [Link to Workflow](https://github.com/WSU-kduncan/ceg3120-cicd-MikeZimmer1299/blob/main/.github/workflows/project4Workflow.yml)
- **Verify**
  - To check if it did the tasking, GitHub Actions will state whether it was successful. If it was successful, go to Docker Hub and verify the three required version tags exist.
  - To verify it uploaded correctly to Docker Hub, run the image in a container.
# Continuous Deployment
## EC2 Instance via Cloud Formation Template
- **Instance Details**
  - The AMI I chose was `ami-084568db4383264d4`, which is Ubuntu 24.04 amd64 server. The instance type is `t2.medium`. I went with recommended volume size of 30GB.
  - For security group, I am using a Cloud Formation Template, and it is set up to allow SSH access from WSU, my home, and internal instances from port 22. Using the CFT, it quickly builds a security group to allow access only from trusted IP addresses.
  - Docker is installed and started via CFT. To check installation, run `sudo docker -v`
## Testing Docker on EC2
- To pull the container, you will need to be logged in to Docker Hub
  - Best practice is to log in with username and PAT
- Once logged in, pull the container with the command `docker pull username/repo:latest`
- After image is pulled, run the command `docker run -it -p 80:4200 mjzimmer121999/zimmerceg-3120:latest`
  - `-it` runs the container in the foreground, `-d` runs the container in the background
    - `-d` is best for running the container after testing is completed
- Validate container is running:
  - Running the command `docker ps -a` will show a list of all containers and their status
  - Running the command `sudo systemctl status docker` will display if container is running
  - From your machine, go to the website that is being run from the container
- To refresh the container if new image is available, run the following commands:
  - `docker kill horror`
    - Kills the current container running
  - `docker pull mjzimmer121999/zimmer-ceg3120`
    - Pulls the updated container from Docker Hub
  - `docker run -d -p 80:4200 --name horror mjzimmer121999/zimmer-ceg3120:latest`
    - Restarts the container with updated configuration
    - Watch for spelling errors. Spelling has been the thorn in my side for the majority of my issues
## Scripting
- `bash` to kill, pull, and run
  - `docker kill horror`
  - `docker rm horror`
  - `docker pull mjzimmer121999/zimmer-ceg3120`
  - `docker run -d -p 80:4200 --name horror --restart=always mjzimmer121999/zimmerceg3120:latest`
    - The `4200` port may need to be changed to `9000`
- To test it, run the script
  - Do not forget to `chmod` the file to allow it to execute
- [Bash Script](https://github.com/WSU-kduncan/ceg3120-cicd-MikeZimmer1299/blob/main/Project5/deployment/refreshImage.sh)
## Webhook Configuration
- Within the EC2 instance, run the command `sudo apt-install webhook` to install the webhook application
  - To check for successful installation, you can run `webhook -version`
- The webhook's contents are: `id` (called mainTask for mine), an `execute` command that runs the `bash` script at the file location, and a `trigger-rule`, which watches for specific 
- To test the webhook once configured, you can run `/path/to/webhook -hooks hooks.json -verbose`, then in your browser url, go to `http://localhost:9000/hooks/mainTask` to verify it works
  - The `-verbose` tag allows the user to watch logs as they come in
- [Definition File](https://github.com/WSU-kduncan/ceg3120-cicd-MikeZimmer1299/blob/main/Project5/deployment/hooks.json)
## Payload Configuration
- I chose to do the webhook through Docker Hub configuration. It seemed best practice to have Docker Hub handle the webhook, as the webhook handles updating container images from Docker Hub.
- The webhook must be added to the Docker Hub repo. Found within the repository under the `Webhooks` tab, you will create the new webhook. It requires a name and a webhook URL
  - Current webhook URL is `http://18.214.111.74:9000/hooks/mainTask`
- Docker Hub states the webhook will run when "an image is pushed to this repo, your workflows will kick off based on your specified webhooks"
- To verify the payload worked, your webhook config on Docker Hub has a history tracker, which is found with the 3 vertical dots at the end of the config. If your webhook has a newly created history, it worked.
## Webhook Config on EC2
- `webhook.service`
  - `ConditionPathExists=` was changed to direct the service to the desired `hooks.json` in EC2 instance home directory, checking if the file exists before executing the service
  - `ExecStart=` was changed to the location of the bash script `hooks.json` via absolute pathing. `-verbose` is used for logging to watch what webhook is doing over time
- Enable and Start
  - To start the webhook, run the command `sudo systemctl start webhook.service`
- Verify working webhook
  - Running the command `journalctl -f -u webhook.service` will be the easiest way, because `journalctl` will not work if a service is not being run
- [Webhook File](https://github.com/WSU-kduncan/ceg3120-cicd-MikeZimmer1299/blob/main/Project5/deployment/webhook.service)
# Resources
- [Tags and Labels Example](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/)
  - Great example of the format and info needed to correctly get the version tags working
- [Tags via CLI](https://git-scm.com/book/en/v2/Git-Basics-Tagging)
  - Explanations on using the `git tag` commands via terminal and the `git tag` capabilities
- "Trigger Rule"
  - Given to class via Prof. Duncan (best professor)
- `webhook.service`
  - Information explained in last lecture by Prof. Duncan, greater detail listed in service file section
- [Jon Wasky](https://github.com/Wamski)
  - Jon allowed me to pick his brain for troubleshooting issues I have been having. He has also led me in the right direction when I have become stumped (such as with Payload Sender and tags in workflow) by asking questions that don't give the answer but point me in the right direction to find the answer.
