FROM ubuntu

RUN apt-get update && DEBIAN_FRONTEND=noninteractive 

RUN apt install -y curl \
  wget 

ARG user=opensearch
ARG group=opensearch
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -s /bin/bash -m ${user} 

RUN mkdir /opt/opensearch
RUN chown -R opensearch:opensearch /opt/opensearch



WORKDIR /opt/opensearch

RUN wget https://artifacts.opensearch.org/releases/bundle/opensearch/2.0.1/opensearch-2.0.1-linux-x64.tar.gz
RUN tar -xf opensearch-2.0.1-linux-x64.tar.gz -C /opt/opensearch
RUN mv /opt/opensearch/opensearch-2.0.1/* /opt/opensearch
RUN chmod +x /opt/opensearch/opensearch-tar-install.sh 

ADD opensearch.yml /opt/opensearch/config/opensearch.yml
ADD jvm.options /opt/opensearch/config/jvm.options

RUN chown -R opensearch:opensearch /opt/opensearch

USER ${uid}:${gid}


CMD ["/opt/opensearch/bin/opensearch"]
