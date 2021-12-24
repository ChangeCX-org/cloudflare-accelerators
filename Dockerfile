# The Dockerfile to stand up  container for cloudflare workers
#download ubuntu-20.04
FROM ubuntu:20.04
#install wget
RUN apt-get update && apt-get install -y wget
#install less
RUN apt-get update && apt-get install -y less

#install sudo 
RUN apt-get update && apt-get install -y sudo
#install bash shell
RUN apt-get update && apt-get install -y bash
#install unzip
RUN apt-get update && apt-get install -y unzip
#install zip
RUN apt-get update && apt-get install -y zip

RUN apt-get update
# We directly answer the questions asked using the printf statement
RUN printf 'y\n1\n\1n' | apt-get install nodejs
RUN apt-get install -y npm


#Creating user ofbiz and adding privileges to it
#login as sudo
RUN adduser --disabled-password --gecos "" cloudflare_workers
#Create a directory named cloudflare_workers
#RUN mkdir /home/cloudflare_workers
#Change the owner of the directory to the user cloudflare_workers
RUN chown -R cloudflare_workers:cloudflare_workers /home/cloudflare_workers
#cd to /usr/local
WORKDIR /usr/local
RUN mkdir cloudflare_workers

COPY . cloudflare_workers

WORKDIR cloudflare_workers

