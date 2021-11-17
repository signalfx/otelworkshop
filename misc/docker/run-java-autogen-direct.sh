docker run --rm -dit \
-e OTEL_SERVICE_NAME=java-autogen-direct-otel \
-e OTEL_RESOURCE_ATTRIBUTES=deployment.environment=$SPLUNK_WORKSHOP_ENV \
-e OTEL_TRACES_EXPORTER=jaeger-thrift-splunk \
-e OTEL_EXPORTER_JAEGER_ENDPOINT=https://ingest.$SPLUNK_REALM.signalfx.com/v2/trace \
-e SPLUNK_ACCESS_TOKEN=$SPLUNK_ACCESS_TOKEN \
--name java-autogen-direct \
--entrypoint="" docker.io/stevelsplunk/splk-java /bin/sh ./manual-inst/run-java-manual-inst-k8s.sh