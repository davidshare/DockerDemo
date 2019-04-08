# DockerDemo
This README explains the concept of containerization and demonstrates the deployment of a react frontend application to AWS using docker containers.


## Introduction
According to Docker(https://www.docker.com/resources/what-container) "A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another."

Containers make it easy to build your applications in one environment and run them in other environments without having any issues. With containers, you can buid, test, ship and run your app on any platform with out having issues. Apps that are run using containers are said to have been containerized. Containerization is the process of bundling an app with all its dependencies, so that it can be run on several other platforms. 

This README provides a brief description of the containerization of a REACT frontend application using Docker. Docker is a tool for the containerization of applications.

## How containers work with applications
A container runs on a thin layer of virtualization engine that runs on the host OS of a physical or virtual machine. Containers are spun in issolated spaces like namespaces or CGROUPS. Each container bundles it's own binaries, and libraries, has it's own processes, and operating system. All the applications that are needed to run the containerized app can be installed inside the container and do not interfer with the applications or processes of thier host machine. Applications installed or run inside the containers stay in the container and are only accessible on the host machine if exposed.

Containers are basically instances of images. An image is a bundled piece of software that contains all the files and tools needed to run applications. Images are templates for containers because containers are created out of images. All the binaries and code inside images can be executed when a container is spun out of it.

This application is a react.js appliction which runs on node.js, so we use Docker as the containerization agent. We use a node-alpine image as the base image and provision our react app on that image. The end product is an image that contains our application and all that is required to run it. We use Dockerfiles for creating images. Our Dockerfile is present in the root directory of the project and contains commands for creating the image we need. When the image has been created, we run a container from that image and expose a port for the host machine to be able to access the running app.

This running container is completely isolated from other running containers and does not interfer with the processes in the host machine even though it shares an OS and a kernel with the machine.

## Tools
- Docker: https://www.docker.com/


## How Setup and deployment
The app was deployed to an AWS EC2 instance using a docker container.


### Create an EC2 instance
- Follow this link to create an EC2 instance: https://hackernoon.com/make-your-amazon-ec2-instance-up-and-running-ab80120eb23
- Note: download the keypair file you create when creating the instance and copy it to a directory locally where you will be able to access it. You will need it to access your linux instance via your terminal.
  

### Reserve an Elastic IP address for the instance you just created
- To allocate an elastic IP address to your instance: https://medium.com/@rakshitshah/simple-way-to-connect-amazon-web-service-ec2-instance-with-domain-name-5839c9748b53
- Note: if you do not have a domain name, you can ignore step2 of the tutorial in the link above.


### SSH into the instance from your local machine
To SSH into the linux ec2 instance you just created you can follow the tutorial in this link: https://thebackroomtech.com/2018/11/05/how-to-ssh-to-an-ec2-instance-from-mac/
  #### Steps
  - Copy the keypair file you downloaded while creating your ec2 instance to a directory; file should end with a `.pem` extension
  - Open your terminal and navigate to the directory where you have placed your keypair file
  - On the terminal, type the following command `ssh -i <keypair_file.pem> ubuntu@<allocated_elastic_ip_address>` 
    - Replace keypair_file.pem with the your own keypair file
    - Replace allocated_elastic_ip_address with the ip address allocated to your instance. You can also use the dns address provided by aws as shown in the tutorial above
  - You will be asked to confirm if you want to add the keypair to your ssh keys, type yes and press enter: tah! dah!! you are now inside your linux instance


### Install docker in the instance you just SSHed into
After you have successfully SSHed into your instance, you should be logged into the terminal of the instance. You can now run commands in that terminal environment.
- To install docker:
  - add the gpg key for the docker repository by executing the following command: `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`
  - add the stable release of the docker repository to the apt sources: `sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"`
  - update your application dependencies: `sudo apt-get update`
  - install docker: `sudo apt-get install -y docker-ce`
  - confirm that docker is installed: `docker --version` - you should see the docker version. 


### clone the project repository
We need git to be able to clone this repository. Verify that git is installed with the following command `git --version`. If git is installed, you should see the version. If it is not installed, you can run the following commands to install it:

    sudo add-apt-repository ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install git
    git --version - to verify that git is installed
- run `git clone https://github.com/davidshare/DockerDemo.git` - to clone the repository
- run `cd DockerDemo` - to enter into the root directory of the project


### Build the docker image
- To build the docker image for our container: `docker build -t selene-frontend .` - note that the period at the end of the command represents the root directory and should not be omitted.
- After the build has been completed, run: `docker image ls` - this will show the image that was just created. Copy the imageid


### Start the container using the docker image
- `docker container run --restart unless-stopped -p 80:8080 <imageId>` - replace `<imageId>` with the the id of the image you just copied. Tah Dah! your container has been started


### Test your app
To test your app, go to your ec2 instance on AWS, copy the IP address you reserved or the DNS address provided by AWS and run it on your browser.

### Exit the linux instance
- press `CTRL+Z` to exit without stopping the running react app
- type `exit` and press enter to exit the linux instance

### How this can be improved upon
- A bash script can be witten to automate the who of this process.
- An ansible or terraform script can be used to also provision this ec2 instance.

