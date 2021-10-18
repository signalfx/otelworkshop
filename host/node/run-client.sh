export OTEL_SERVICE_NAME=node-otel-client
export OTEL_RESOURCE_ATTRIBUTES=deployment.environment:apm-workshop
node -r @splunk/otel/instrument app.js