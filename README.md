
Required for wsl docker:

wsl -d docker-desktop
sysctl -w vm.max_map_count=262144





curl -v master1:9200
curl -v -XGET master1:9200/_cluster/health
curl -XPUT master1:9200/test-index2
curl -XGET master1:9200/_cat/indices