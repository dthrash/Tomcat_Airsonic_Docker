FROM tomcat
LABEL description="Create new docker image from tomcat to allow airsonic docker to be customized"

RUN echo deb http://www.deb-multimedia.org testing main non-free \
                  >>/etc/apt/sources.list
RUN apt-get -y update
RUN apt-get install -y --allow-unauthenticated deb-multimedia-keyring
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get autoremove
#ffmpeg fails!
RUN apt-get install -y --allow-unauthenticated ffmpeg
RUN apt-get install -y --allow-unauthenticated lame

ADD https://github.com/airsonic/airsonic/releases/download/v10.1.1/airsonic.war /usr/loca/tomcat/webapps/

#Tomcat Config - Mysql connection specified here
COPY /opt/apps/airsonic/tomcat/conf/* /usr/local/tomcat/conf/

#Required for mysql jdbc - Specific to my tomcat configuration
COPY /opt/apps/airsonic/tomcat/lib/mysql-connector-java-5.1.46-bin.jar /usr/local/tomcat/lib

CMD ["catalina.sh", "run"]

#Airsonic Config
#Configuration changes should always be made on the docker host and not within the UI, since the UI configs will not persist
COPY /opt/apps/airsonic/app/* /var/airsonic

RUN ln -s /usr/bin/ffmpeg /var/airsonic/transcode


