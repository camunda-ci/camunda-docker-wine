FROM gcr.io/ci-30-162810/chrome:v0.1.2

# install wine
RUN yum -y install https://harbottle.gitlab.io/wine32/7/i386/wine32-release.rpm && \
    yum -y install yum-plugin-versionlock && \
    yum versionlock add google-chrome-stable && \
    yum versionlock add wget && \
    install-packages.sh wine.i686 libXScrnSaver gtk3
