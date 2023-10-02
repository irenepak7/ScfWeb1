FROM debian:11 
EXPOSE 1935

WORKDIR /root

RUN apt update &&\
    apt install -y build-essential wget git libssl-dev libpcre3-dev zlib1g-dev ffmpeg python3 python3-pip &&\
    apt-get -y install nginx &&\
    apt-get -y remove nginx  &&\
    apt-get clean

RUN cd /usr/src/ &&\
    mkdir nginx &&\
    cd nginx &&\
    git clone https://github.com/arut/nginx-rtmp-module.git &&\
    wget http://nginx.org/download/nginx-1.25.2.tar.gz &&\
    tar xzf nginx-1.25.2.tar.gz &&\
    rm -rf nginx-1.25.2.tar.gz &&\
    cd nginx-1.25.2 &&\
    ./configure --prefix=/var/www --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-http_ssl_module --without-http_proxy_module --add-module=/usr/src/nginx/nginx-rtmp-module &&\
    mkdir -p /var/www &&\
    make &&\
    make install

RUN apt autoremove -y build-essential libssl-dev libpcre3-dev zlib1g-dev &&\
    apt autoclean

COPY nginx.conf /etc/nginx/nginx.conf

COPY default /etc/nginx/sites-enabled/default

# RUN /usr/sbin/nginx -t &&\
#    sleep 10

# CMD service nginx start
CMD ["nginx", "-g;"]
