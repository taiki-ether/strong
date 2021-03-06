# Pull base image.
FROM centos:6.10
MAINTAINER EtherGladiator
WORKDIR /tmp/

# yum update
RUN rpm -Uhv http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y update
RUN yum install -y vim git sudo passwd wget make gcc tar readline-devel
RUN yum install -y openssl-devel openssh openssh-server openssh-clients
RUN yum install -y install libxml2 libxml2-devel libxslt libxslt-devel

# install httpd
RUN yum install -y httpd
COPY ./contents/config/httpd.conf-gamy /etc/httpd/conf/httpd.conf
COPY ./contents/config/httpd-vhosts.conf /etc/httpd/conf.d/httpd-vhosts.conf
RUN mkdir /var/log/httpd/patriot
RUN mkdir /var/log/gamy
# install java(1.8.0)
RUN yum install -y java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64

# install tomcat7(7.0.90)
RUN yum install -y tomcat --enablerepo=epel
COPY ./contents/config/server.xml /usr/share/tomcat/conf/server.xml
COPY ./contents/app/ROOT.war /usr/share/tomcat/webapps/ROOT.war

# make start script
RUN echo -e "/etc/init.d/httpd start\n/etc/init.d/tomcat start\n/bin/bash\nwhile :\ndo\nsleep 5\ndone" > /startService.sh
RUN chmod o+x /startService.sh


EXPOSE 80 8080
CMD sh -x /startService.sh
