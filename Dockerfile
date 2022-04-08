FROM debian:11 
EXPOSE 9000

WORKDIR /root

RUN mkdir -p /root/build &&\
    apt update &&\
    apt install -y build-essential wget git libssl-dev libpcre3-dev zlib1g-dev ffmpeg python3 python3-pip

RUN cd /root/build &&\
    wget https://openresty.org/download/openresty-1.19.9.1.tar.gz &&\
    tar -zxvf openresty-1.19.9.1.tar.gz &&\
    rm openresty-1.19.9.1.tar.gz &&\
    wget https://github.com/arut/nginx-rtmp-module/archive/refs/tags/v1.2.2.tar.gz &&\
    tar -zxvf v1.2.2.tar.gz &&\
    rm v1.2.2.tar.gz &&\
    cd openresty-1.19.9.1 &&\
    ./configure --add-module=../nginx-rtmp-module-1.2.2 &&\
    make -j4 &&\
    make install

RUN apt autoremove -y build-essential libssl-dev libpcre3-dev zlib1g-dev &&\
    apt autoclean &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm /root/build -r

ENTRYPOINT ["/tmp/openresty/nginx/sbin/nginx","-g","daemon off;"]