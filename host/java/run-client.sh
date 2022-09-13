# The following environment variables would apply an attribute to all spans emitted
# from the application.  In the workshop, we apply this tag to all Spans via the Collector
# configuration and therefore don't need to set it at the application layer.
#export OTEL_RESOURCE_ATTRIBUTES=deployment.environment=apm-workshop

# This environment variable defines the location of the Span receiver.  The address below is the default
# value for the Java instrumentation and therefore doesn't need to be explicitly set.  It's provided here
# reference.
#export OTEL_EXPORTER_OTLP_ENDPOINT=http://127.0.0.1:4317

export OTEL_SERVICE_NAME=java-otel-client

java \
-Dexec.executable="java" \
-Dsplunk.metrics.enabled=false \
-javaagent:/opt/splunk-otel-javaagent.jar \
-jar ./target/java-app-1.0-SNAPSHOT.jar