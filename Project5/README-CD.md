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
  - Docker is installed and started via CFT

## Testing Docker on EC2


## Scripting


## Webhook Configuration


## Payload Configuration


## Webhook Config on EC2


# Resources
- [Tags and Labels Example](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/)
  - Great example of the format and info needed to correctly get the version tags working
- [Tags via CLI](https://git-scm.com/book/en/v2/Git-Basics-Tagging)
  - Explanations on using the `git tag` commands via terminal and the `git tag` capabilities

