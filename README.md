# Jupyter Notebook Python and Spark

This docker image allows the development of pyspark through the user of Jupyter.

## Basic Use

The docker images can be found in the [Miner Kasch repository](https://hub.docker.com/r/minerkasch/jupyter-pyspark/) on Docker Hub.

### Obtaining the Docker Image

To get the docker image, the following `pull` command can be used.

    docker pull minerkasch/jupyter-pyspark


### Running the Image

The following command starts a container with the Notebook server listening on HTTP connections on port 8888 with a randomly generated authentication token.

    docker run -it --rm -p 8888:8888 \
    -v /some/host/folder/notebooks:/root/notebooks \
    --name=training minerkasch/jupyter-pyspark \
    jupyter notebook

To access the notebook server, copy/paste the URL into your browser.


### Sharing Jupyter Notebooks with the Image

To make notebook files on your local host available to the Jupyter server on the Docker container, change the sample path (`/some/host/folder/notebooks`) to a directory, on your local host, that contains Jupyter notebook file.


## Using Spark

The container server is configured to run pyspark in local mode. The following steps must be completed to use pyspark.

1. Open a Python 2 or 3 notebook
2. Define the `PYSPARK_PYTHON` environment variable
3. Create a `SparkContext` configured for local mode

An example application looks like the following: 

    import os
    # Change to '/usr/bin/python' for python 2
    os.environ['PYSPARK_PYTHON'] = '/usr/bin/python3'

    import pyspark
    sc = pyspark.SparkContext('local[*]')


    # Run a test to prove it works
    rdd = sc.parallelize(range(1000))
    rdd.takeSample(False, 5)


## Using the Image Offline

This section contains instructions on how to save the image locally and load the image from a saved file

### Saving the Image to a File

To save the image locally to a file, use the `docker save` command. The `-o` option allows you to specify a path and filename to save the image as. The format of the command is `docker save [OPTIONS] IMAGE`. An example command to save the `minerkasch/jupyter-pyspark` image to your downloads folder would look like the following.

    docker save -o ~/Downloads/jupyter-pyspark.docker minerkasch/jupyter-pyspark

After the image is saved it can be copied to a USB or network share.

### Loading the Image into Docker

To load an archive into Docker, use the `docker load` command. The `-i` options allows you to specify a path and filename of an archive to load. The format of the command is `docker load [OPTIONS]`. An example of command to load an archive would look like the following. 

    docker load -i ~/Downloads/jupyter-pyspark.docker


### Running Docker in Windows

As always, running things in windows is more complicated. If you are NOT running Windows 10 Pro, you will have to download and install [Docker Toolbox for Windows](https://docs.docker.com/toolbox/toolbox_install_windows/). This utilizes Virtualbox to simulate a docker environment.

Make sure to follow the [install guide](https://docs.docker.com/toolbox/toolbox_install_windows/#step-2-install-docker-toolbox) and install ALL components.

After Docker toolbox is installed you can open the Docker QuickStart Terminal and you will be presented with a bash terminal in Windows! The QuickStart Terminal may take a few minutes to initialize, so please be patient.

Once the terminal has started you are ready to load your docker image. You can use the command from the previous section to load the docker image from an archive or use `docker pull` to grab the latest image from Docker Hub.

Before starting the container, you will need to find your docker VM's IP. To do this use the `docker-machine ip` command. The following is an example and the IP it outputs might be different.

    docker-machine ip
    192.168.99.100

Now that you have this IP address you can launch the image with the following command:

    docker run -it --rm -p 8888:8888 \
    -v /some/host/folder/notebooks:/root/notebooks \
    --name=training \
    minerkasch/jupyter-pyspark /bin/bash

This will launch the image and you will have access to the shell. From here you can start Jupyter by issuing the command `jupyter notebook` and your output should look like the following.

    # jupyter notebook
    [I 22:52:35.668 NotebookApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
    [W 22:52:36.198 NotebookApp] WARNING: The notebook server is listening on all IP addresses and not using encryption. This is not recommended.
    [I 22:52:36.211 NotebookApp] Serving notebooks from local directory: /root/notebooks
    [I 22:52:36.211 NotebookApp] 0 active kernels
    [I 22:52:36.212 NotebookApp] The Jupyter Notebook is running at:
    [I 22:52:36.212 NotebookApp] http://[all ip addresses on your system]:8888/?token=2b730d98281f70ca4fd315d81c55cc00d11cd800ccaf3b16
    [I 22:52:36.212 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
    [C 22:52:36.213 NotebookApp] 
        
        Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://localhost:8888/?token=2b730d98281f70ca4fd315d81c55cc00d11cd800ccaf3b16


Instead of copying the address directly into your local host's browser you will need to replace `localhost` with the IP address of the Docker VM, found in the previous step. In this example the URL you would insert into your browser would be:

    http://192.168.99.100:8888/?token=2b730d98281f70ca4fd315d81c55cc00d11cd800ccaf3b16


## Useful Docker Commands


### Build the docker image

    docker build -t minerkasch/jupyter-pyspark .


### Run the docker container

    docker run -it --rm -p 8888:8888 \
    -v /some/host/folder/notebooks:/root/notebooks \
    --name=training \
    minerkasch/jupyter-pyspark /bin/bash


### List running containers
    
    docker ps


### Attach to a running container

    docker exec -it training /bin/bash


### Stop container

    docker stop training


### Remove containers that are exited

    docker rm $(docker ps -q -f status="exited")
