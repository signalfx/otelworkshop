docker run --rm -dit \
-e OTEL_RESOURCE_ATTRIBUTES=deployment.environment=$SPLUNK_WORKSHOP_ENV \
-e OTEL_SERVICE_NAME=python-autogen-direct-otel \
-e OTEL_EXPORTER_JAEGER_ENDPOINT=https://ingest.$SPLUNK_REALM.signalfx.com/v2/trace \
-e OTEL_TRACES_EXPORTER=jaeger-thrift-splunk \
-e SPLUNK_ACCESS_TOKEN=$SPLUNK_ACCESS_TOKEN \
-e REDISHOST=127.0.0.1 \
-p 6379:6379 \
--name python-autogen-direct \
--entrypoint="" docker.io/stevelsplunk/splk-python-autogen /bin/bash run-autogen.sh