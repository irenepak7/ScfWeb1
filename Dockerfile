FROM debian:11 
EXPOSE 9000

WORKDIR /root

RUN mkdir -p /root/build &&\
    cp /etc/apt/sources.list /etc/apt/sources.list.backup &&\ 
    sed -i s/deb.debian.org/mirrors.cloud.tencent.com/g /etc/apt/sources.list &&\
    sed -i s/security.debian.org/mirrors.cloud.tencent.com/g /etc/apt/sources.list &&\
    apt update &&\
    apt install -y build-essential wget git libssl-dev libpcre3-dev zlib1g-dev ffmpeg python3 python3-pip

RUN cd /root/build &&\
    wget http://nginx.org/download/nginx-1.21.6.tar.gz &&\
    tar -zxvf nginx-1.21.6.tar.gz &&\
    rm nginx-1.21.6.tar.gz &&\
    wget https://github.com/arut/nginx-rtmp-module/archive/refs/tags/v1.2.2.tar.gz &&\
    tar -zxvf v1.2.2.tar.gz &&\
    rm v1.2.2.tar.gz &&\
    cd nginx-1.21.6 &&\
    ./configure --add-module=../nginx-rtmp-module-1.2.2 &&\
    make -j4 &&\
    make install

RUN apt autoremove -y build-essential libssl-dev libpcre3-dev zlib1g-dev &&\
    apt autoclean &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm /root/build -r

ADD nginx.conf /usr/local/nginx/conf/nginx.conf

ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]
