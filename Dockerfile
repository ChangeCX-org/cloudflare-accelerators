# The Dockerfile to stand up ofbiz container for hosting bnc code
#download ubuntu-20.04
FROM ubuntu:20.04

EXPOSE 8080
EXPOSE 8443

#install wget
RUN apt-get update && apt-get install -y wget
#install less
RUN apt-get update && apt-get install -y less
#install git 
RUN apt-get update && apt-get install -y git
#install sudo 
RUN apt-get update && apt-get install -y sudo
#install bash shell
RUN apt-get update && apt-get install -y bash
#install unzip
RUN apt-get update && apt-get install -y unzip
#install zip
RUN apt-get update && apt-get install -y zip



#install headless gradle
RUN wget https://services.gradle.org/distributions/gradle-4.10.2-bin.zip
RUN unzip gradle-4.10.2-bin.zip
RUN rm gradle-4.10.2-bin.zip
RUN mv gradle-4.10.2 /usr/local/gradle
RUN echo 'export PATH=/usr/local/gradle/bin:$PATH' >> /etc/profile





# This is in accordance to : https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
RUN apt-get update && \
	apt-get install -y openjdk-8-jdk-headless && \
	apt-get install -y ant && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;
	
# Fix certificate issues, found as of 
# https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/983302
RUN apt-get update && \
	apt-get install -y ca-certificates-java && \
	apt-get clean && \
	update-ca-certificates -f && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

# Setup JAVA_HOME, this is useful for docker commandline
#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
#RUN export JAVA_HOME
#install gradle
#RUN apt-get update && apt-get install -y gradle


#Creating user ofbiz and adding privileges to it
#login as sudo
RUN adduser --disabled-password --gecos "" ofbiz
#Create a directory named ofbiz
#RUN mkdir /home/ofbiz
#Change the owner of the directory to the user ofbiz
RUN chown -R ofbiz:ofbiz /home/ofbiz
#cd to /usr/local
WORKDIR /usr/local
RUN mkdir ofbiz

COPY . ofbiz

#Use for local build testing
#COPY credentials /root/.aws/credentials
#COPY config /root/.aws/config

WORKDIR ofbiz
#RUN rm -rf hot-deploy/html
RUN mkdir runtime/logs

RUN wget https://github.com/Droplr/aws-env/raw/master/bin/aws-env-linux-amd64 -O /aws-env
RUN chmod +x /aws-env

#go to /opt
WORKDIR /opt
#create a directory named newrelic
RUN mkdir newrelic
# go to /opt/newrelic
WORKDIR /opt/newrelic

#Download newrelic agent
RUN wget https://download.newrelic.com/newrelic/java-agent/newrelic-agent/newrelic-agent-java-linux-x64.tar.gz
#Extract the newrelic agent
RUN tar -xvzf newrelic-agent-java-linux-x64.tar.gz
#Remove the newrelic agent tar file
RUN rm newrelic-agent-java-linux-x64.tar.gz
#rename newrelic-agent-java-linux-x64 to newrelic
RUN mv newrelic-agent-java-linux-x64 newrelic
#go to /opt/newrelic/newrelic
WORKDIR /opt/newrelic/newrelic
#Copy Newrelic.yml from local directory to /opt/newrelic/newrelic
COPY newrelic.yml /opt/newrelic/newrelic

#Execute ./gradlew ofbiz -start as ENTRYPOINT
ENTRYPOINT ["bash", "./entrypoint.sh"]

