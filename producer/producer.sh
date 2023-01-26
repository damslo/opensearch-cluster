#!/bin/bash
echo "START"
healthcheck=$(curl -s -X GET master1:9200/_cluster/health |jq -r '.status')


while [ "$healthcheck" != "green" ]
do
echo "cluster not ready: $healthcheck"
sleep 10
done

echo creating templates...

curl -s -X PUT "master1:9200/_component_template/component_template1?pretty" -H 'Content-Type: application/json' -d'
{
  "template": {
    "mappings": {
      "properties": {
        "@timestamp": {
          "type": "date"
        },
        "text_field1_comp": {
          "type": "text"
        },
        "keyword_field1_comp": {
          "type": "keyword"
        }
      }
    }
  }
}
'


curl -s -X PUT "master1:9200/_index_template/template_1?pretty" -H 'Content-Type: application/json' -d'
{
  "index_patterns": ["sample_index*"],
  "template": {
    "settings": {
      "number_of_shards": 1
    },
    "mappings": {
      "_source": {
        "enabled": true
      },
      "properties": {
        "host_name": {
          "type": "keyword"
        }
      }
    },
    "aliases": {
      "sample1": { }
    }
  },
  "composed_of": ["component_template1"]
}
'
echo creating index
curl -s -X PUT "master1:9200/sample_index1"


i=0


while :
do
echo "sending data to opensearch, doc nr: $i"
curl -s -X POST "master1:9200/sample_index1/_doc/?pretty" -H 'Content-Type: application/json' --data @<(cat <<EOF
{
  "text_field1_comp": "this is message nr: $i",
  "host_name": "$(hostname)",
  "keyword_field1_comp": "something"
 
}
EOF
)

  #"@timestamp": "$(date)",

i=$((i+1))
sleep 10
done






echo "exit"