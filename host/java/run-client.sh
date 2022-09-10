#export OTEL_RESOURCE_ATTRIBUTES=deployment.environment=apm-workshop
#export OTEL_EXPORTER_OTLP_ENDPOINT=http://127.0.0.1:4317
export OTEL_SERVICE_NAME=java-otel-client

java \
-Dexec.executable="java" \
-Dsplunk.metrics.enabled=false \
-javaagent:/opt/splunk-otel-javaagent.jar \
-jar ./target/java-app-1.0-SNAPSHOT.jar