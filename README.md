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

To use notebooks, stored on your local host, with Jupyter on the Docker container, change the sample path (`/some/host/folder/notebooks`) to a directory, on your local host, that contains Jupyter notebook file.


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


## Useful Docker Commands


### Build the docker image

    docker build -t training .


### Run the docker container

    docker run -itd --rm -p 8888:8888 \
    -v /some/host/folder/notebooks:/root/notebooks \
    --name=training \
    training /bin/bash


### List running containers
    
    docker ps


### Attach to a running container

    docker exec -it training /bin/ash


### Stop container

    docker stop training


### Remove containers that are exited

    docker rm $(docker ps -q -f status="exited")

