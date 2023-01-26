FROM alpine:3.14
RUN apk add --no-cache curl bash jq
ADD producer.sh /opt/producer.sh
RUN chmod +x /opt/producer.sh
#CMD [/opt/producer.sh]
#CMD ["sleep","3600"]
CMD ["/bin/bash", "-c", "/opt/producer.sh"].