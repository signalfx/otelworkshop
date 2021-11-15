docker run --rm -dit \
-e OTEL_SERVICE_NAME=java-autogen-direct-otel \
-e OTEL_RESOURCE_ATTRIBUTES=deployment.environment=apm-workshop \
-e OTEL_EXPORTER_OTLP_ENDPOINT=https://ingest.$SPLUNK_REALM.signalfx.com/v2/trace/otlp \
-e SPLUNK_ACCESS_TOKEN=$SPLUNK_ACCESS_TOKEN \
--name java-autogen-direct docker.io/stevelsplunk/splk-java:latest

docker exec -it java-autogen-direct /bin/sh ./manual-inst/run-java-manual-inst-k8s.sh