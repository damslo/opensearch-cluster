FROM ubuntu


RUN apt-get update && DEBIAN_FRONTEND=noninteractive 

RUN apt install -y curl \
  wget \
  vim



# Set user and group
ARG user=opensearch
ARG group=opensearch
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -s /bin/bash -m ${user} 

# Switch to user

# Run non-privileged command

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

#CMD ["/usr/bin/sleep 50000"]
#ENTRYPOINT chown -R opensearch:opensearch /opt/data
CMD ["/opt/opensearch/bin/opensearch"]
#&& /opt/opensearch/opensearch-tar-install.sh &

#CMD ["/usr/bin/sleep","50000"]





#RUN mkdir /usr/share/elasticsearch
#WORKDIR /usr/share/elasticsearch
#RUN curl -S -L --output /tmp/elasticsearch.tar.gz https://artifacts-no-kpi.elastic.co/downloads/elasticsearch/elasticsearch-8.6.0-linux-$(arch).tar.gz
#RUN tar -zxf /tmp/elasticsearch.tar.gz --strip-components=1
#COPY config/elasticsearch.yml config/
#COPY config/log4j2.properties config/log4j2.docker.properties


#RUN sed -i -e 's/ES_DISTRIBUTION_TYPE=tar/ES_DISTRIBUTION_TYPE=docker/' bin/elasticsearch-env && \
#    mkdir data && \
#    mv config/log4j2.properties config/log4j2.file.properties && \
#    mv config/log4j2.docker.properties config/log4j2.properties && \
#    find . -type d -exec chmod 0555 {} + && \
#    find . -type f -exec chmod 0444 {} + && \
#    chmod 0555 bin/* jdk/bin/* jdk/lib/jspawnhelper modules/x-pack-ml/platform/linux-*/bin/* && \
#    chmod 0775 bin config config/jvm.options.d data logs plugins && \
#    find config -type f -exec chmod 0664 {} +
#
#
#RUN apt-get upgrade -y && \
#    apt-get install -y --no-install-recommends \
#        ca-certificates curl netcat p11-kit unzip zip  && 
#    rm -rf /var/lib/apt/lists/* && 