FROM ubuntu

################################################################################
# Set up OS
################################################################################

EXPOSE 8888
WORKDIR /root

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

COPY util/* /usr/local/bin/

RUN \
  apt-get update && \
  apt-get -y install wget \
    curl \
    tar \
    openjdk-8-jre

################################################################################
# Python 2
################################################################################

COPY config/jupyter_notebook_config.py /root/.jupyter/

RUN \
  apt-get -y install python \
    python-pip \
    python-numpy \
    python-pandas \
    python-sklearn \
    python-pycurl \
    python-matplotlib && \
  pip install --no-cache-dir --upgrade setuptools pip && \
  min-pip jupyter \
    jupyter_dashboards \
    tensorflow && \
#  jupyter dashboards quick-setup --sys-prefix && \
  echo "### Cleanup unneeded files" && \
  rm -rf /usr/lib/python2*/*/tests && \
  rm -rf /usr/lib/python2*/ensurepip && \
  rm -rf /usr/lib/python2*/idlelib && \
  rm -rf /usr/share/man/* && \
  clean-pyc-files /usr/lib/python2*

################################################################################
# Python 3
################################################################################

RUN \
  apt-get -y install python3 \
    python3-pip \
    python3-numpy \
    python3-pandas \
    python3-sklearn \
    python3-pycurl \
    python3-matplotlib && \
  pip3 install --no-cache-dir --upgrade setuptools pip && \
  min-pip3 ipykernel \
    tensorflow && \
  python3 -m ipykernel install --user && \
  echo "### Cleanup unneeded files" && \
  rm -rf /usr/lib/python3*/*/tests && \
  rm -rf /usr/lib/python3*/ensurepip && \
  rm -rf /usr/lib/python3*/idlelib && \
  rm -rf /usr/share/man/* && \
  clean-pyc-files /usr/lib/python3*


################################################################################
# Spark
################################################################################

ENV APACHE_SPARK_VERSION 2.2.1
ENV HADOOP_VERSION 2.7

RUN \
  cd /tmp && \
  wget -q http://apache.cs.utah.edu/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
  tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local && \
  rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
  cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip

RUN apt-get clean