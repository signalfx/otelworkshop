docker run --rm -dit \
-e OTEL_SERVICE_NAME=java-autogen-otel \
-e OTEL_RESOURCE_ATTRIBUTES=deployment.environment=apm-workshop \
-e OTEL_EXPORTER_OTLP_ENDPOINT=otelcol:4317 \
--network otel-net \
--name java-autogen-otel docker.io/stevelsplunk/splk-java:latest

docker exec -it java-autogen-otel /bin/sh ./manual-inst/run-java-manual-inst-k8s.sh