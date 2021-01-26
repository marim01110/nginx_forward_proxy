FROM centos:centos7
MAINTAINER Kohei Yoshikawa <marimo3418@neko2.net>
WORKDIR /opt
ADD ./startup.sh /
RUN yum update -y\
    && yum upgrade -y\
    && yum install -y wget git patch gcc pcre pcre-devel openssl openssl-devel gd gd-devel
RUN wget http://nginx.org/download/nginx-1.19.6.tar.gz
RUN tar -xzvf nginx-*.*.*.tar.gz\
    && rm -r nginx-*.*.*.tar.gz
RUN git clone https://github.com/chobits/ngx_http_proxy_connect_module.git
RUN cd nginx-*.*.*\
    && patch -p1 < /opt/ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_1018.patch\
    && ./configure --add-module=/opt/ngx_http_proxy_connect_module\
    && make && make install
RUN rm -r /opt/*
#RUN yum remove -y wget git patch gcc pcre pcre-devel openssl openssl-devel gd gd-devel
RUN chmod +x /startup.sh
CMD ["/startup.sh"]
