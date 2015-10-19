FROM registry.camunda.com/camunda-ci-base-ubuntu:latest

# install wine and xvfb
RUN dpkg --add-architecture i386
RUN install-packages.sh wine

USER camunda

# install nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash

# install stable node
RUN bash -c 'source /home/camunda/.nvm/nvm.sh && nvm install stable && nvm alias default stable'

USER root
