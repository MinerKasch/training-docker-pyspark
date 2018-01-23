# Use alpine as the parent image
FROM alpine


################################################################################
# Set up OS
################################################################################

EXPOSE 8888
WORKDIR /root

ENV SHELL=/bin/bash
ENV JAVA_HOME=/usr/lib/jvm/default-jvm

ENTRYPOINT ["/sbin/tini", "--"]
#CMD ["jupyter-notebook"]

COPY util/* /usr/local/bin/

RUN \
  min-apk binutils && \
  min-apk \
    bash \
    musl-dev \
    gcc \
    g++ \
    tini \
    openjdk8 && \
  echo "### Cleanup unneeded files" && \
  rm /bin/bashbug && \
  rm -rf /usr/include/c++/*/java && \
  rm -rf /usr/include/c++/*/javax && \
  rm -rf /usr/include/c++/*/gnu/awt && \
  rm -rf /usr/include/c++/*/gnu/classpath && \
  rm -rf /usr/include/c++/*/gnu/gcj && \
  rm -rf /usr/include/c++/*/gnu/java && \
  rm -rf /usr/include/c++/*/gnu/javax && \
  rm /usr/libexec/gcc/x86_64-alpine-linux-musl/*/cc1obj && \
  rm /usr/bin/gcov* && \
  rm /usr/bin/gprof && \
  rm /usr/bin/*gcj


################################################################################
# Python 2
################################################################################

COPY config/jupyter_notebook_config.py /root/.jupyter/

RUN \
  min-apk \
    python \
    python-dev \
    py-pip && \
  pip install --no-cache-dir --upgrade setuptools pip && \
  min-pip jupyter \
    jupyter_dashboards && \
  jupyter dashboards quick-setup --sys-prefix && \
  echo "### Cleanup unneeded files" && \
  rm -rf /usr/lib/python2*/*/tests && \
  rm -rf /usr/lib/python2*/ensurepip && \
  rm -rf /usr/lib/python2*/idlelib && \
  rm /usr/lib/python2*/distutils/command/*exe && \
  rm -rf /usr/share/man/* && \
  clean-pyc-files /usr/lib/python2*


################################################################################
# Python 3
################################################################################

RUN \
  min-apk \
    python3 \
    python3-dev && \
  pip3 install --no-cache-dir --upgrade setuptools pip && \
  min-pip3 ipykernel && \
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
  wget -q http://apache.claz.org/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
  tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local && \
  rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
  cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip
