export SPLUNK_ACCESS_TOKEN=YOURTOKENHERE
export OTEL_EXPORTER_JAEGER_ENDPOINT=https://ingest.YOURREALMHERE.signalfx.com/v2/trace
export OTEL_RESOURCE_ATTRIBUTES=deployment.environment=YOURINITIALSHERE-apm-workshop
export OTEL_TRACES_EXPORTER=jaeger-thrift-splunk
export OTEL_SERVICE_NAME=py-otel-autogen-direct
export SPLUNK_TEST_URL=https://api.github.com

# ensure path is correct
export PATH="$HOME/.local/bin:$PATH"
splunk-py-trace python3 ./python-reqs-autogen-func.py