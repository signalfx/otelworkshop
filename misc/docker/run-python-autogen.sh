docker run --rm -dit \
-e OTEL_SERVICE_NAME=python-autogen-otel \
-e OTEL_RESOURCE_ATTRIBUTES=deployment.environment=$SPLUNK_WORKSHOP_ENV \
-e OTEL_EXPORTER_OTLP_ENDPOINT=otelcol:4317 \
-e REDISHOST=127.0.0.1 \
-p 6379:6379 \
--network otel-net \
--name python-autogen \
--entrypoint="" docker.io/stevelsplunk/splk-python-autogen /bin/bash run-autogen.sh