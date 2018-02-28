FROM registry.camunda.com/camunda-ci-base-centos:latest

# install required packages for wine and headless chrome on centos 7.3
RUN yum -y install https://harbottle.gitlab.io/wine32/7/i386/wine32-release.rpm && \
    install-packages.sh \
      alsa-lib.x86_64 \
      gtk3 \
      libXScrnSaver \
      wine.i686

USER camunda

# install nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

# install stable node
RUN bash -c 'source /home/camunda/.nvm/nvm.sh && nvm install stable && nvm alias default stable'

USER root
