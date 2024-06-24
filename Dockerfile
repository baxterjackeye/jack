# ===================================================================
# Main Docker image for production builds
# ===================================================================

# Use Ubuntu 20.04 as base image
FROM ubuntu:20.04

# Update package lists and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    default-jdk \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Fetch the latest Tomcat 9 version number
RUN set -ex && \
    TOMCAT_VERSION=$(curl -s https://downloads.apache.org/tomcat/tomcat-9/ | \
    grep -Eo 'v9\.[0-9]+\.[0-9]+' | \
    sort -V | \
    tail -n 1) && \
    echo "Latest Tomcat version: $TOMCAT_VERSION" && \
    wget https://downloads.apache.org/tomcat/tomcat-9/${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION#v}.tar.gz && \
    tar -xzf apache-tomcat-${TOMCAT_VERSION#v}.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION#v} /usr/local/tomcat && \
    rm apache-tomcat-${TOMCAT_VERSION#v}.tar.gz
# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Expose Tomcat port
EXPOSE 8080

# Set the working directory
WORKDIR /usr/local/tomcat

# Copy the contents of the webapps directory into the webapps directory of Tomcat
 COPY /* ./webapps/

# Start Tomcat
CMD ["catalina.sh", "run"]
