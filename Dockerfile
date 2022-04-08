FROM debian:11 

EXPOSE 9000

WORKDIR /root
ADD app /root/

RUN apt update &&\
    apt install -y python3 python3-pip

ENTRYPOINT ["python","-m","http.server","9000"]
