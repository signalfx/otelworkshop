docker run --rm -dit \
-e OTEL_SERVICE_NAME=java-autogen-otel \
-e OTEL_RESOURCE_ATTRIBUTES=deployment.environment=$SPLUNK_WORKSHOP_ENV \
-e OTEL_EXPORTER_OTLP_ENDPOINT=otelcol:4317 \
--network otel-net \
--name java-autogen-otel \
--entrypoint=""  quay.io/vvydier123/splk-java:latest bin/sh ./manual-inst/run-java-manual-inst-k8s.sh
