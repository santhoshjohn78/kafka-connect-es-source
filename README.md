#  Elasticsearch source kafka connector

## Overview

This is a kafka connect project that uses an open source Elasticsearch source connector. This connector polls the source which is an Elasticsearch index extracts the documents and publishes the documents into a kafka topic

## Kafka producers
This project creates a kafka connect producer with the name mentioned in the connector config

## Running locally

1. Clone this project `git clone <project_url>`

2. Build the open soruce connector

   1. clone this project `git clone https://github.com/DarioBalinzo/kafka-connect-elasticsearch-source.git`
   2. Build this project `mvn clean package -DskipTests`
   3. Copy the jar with dependency to test/data/connect-jars folder

3. Run the docker containers in test
   1. You would need a local elasticsearch, kafka broker, zookeeper, schema registry and kafka connect
   2. goto test folder and run `docker-compose up kafkaconnect-es-poc`

4. Upload a sample PIQ document into local elastic search
   ```curl
   
      curl -XPOST "https://localhost:9200/pocindex/1/8" -d' 
      {
         "empid": "CC95388504",
         "departmentid": "D02250425211718",
         "empname": "xyw",
         "sex": "M",
         "dob": "2020-06-22",
         "lastUpdated": "2020-08-17 08:30:42.889"
        }
   ```

5. Optional for testing. Create a topic with the name example_topic. This is optional because kafka connect will automatically create this topic when the connector publishes the first message if you don't in local.


6. Register the Elasticsearch source connector

   ```curl 
    curl -X POST -H "Content-Type: application/json" --data @config-local.json http://localhost:8083/connectors | jq
   
   ```

7. Test if the converter picked up the elastic search document and published it into the topic


