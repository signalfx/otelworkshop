#export OTEL_RESOURCE_ATTRIBUTES=deployment.environment=apm-workshop
export OTEL_SERVICE_NAME=node-otel-client
node -r @splunk/otel/instrument app.js