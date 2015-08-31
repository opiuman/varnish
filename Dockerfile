FROM centos:7

RUN yum update -y && \
  yum install -y epel-release && \
  yum install -y varnish && \
  yum install -y libmhash-devel && \
  yum clean all

CMD ["varnishd", "-F", "-f", "/etc/varnish/default.vcl"]
EXPOSE 80