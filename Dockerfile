from bcleonard/calibre
ADD . /root/
RUN yum install cronie -y
RUN sh /root/bootstrap.sh
RUN /usr/sbin/crond -n