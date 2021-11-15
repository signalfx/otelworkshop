## Docker based APM examples

---
### Prep:
Create environment variables with your Splunk token and realm- substitute yours for the variables in caps:  
```
export SPLUNK_ACCESS_TOKEN=YOURTOKENHERE
```
```
export SPLUNK_REALM=YOURREALMHERE
```

---
### Example 1: Python Microservice w/ Local Otel Collector
A local docker network with an OpenTelemetry Collector container and a container with a Python microservice example with a redis client and server in same container.  

Step 1: Create a local docker network called `otel-net`  
```
source setup-docker.sh
```

Step 2: Run Otel Collector docker container in the `otel-net` docker bridged network:
```
source run-otelcol.sh
```

Step 3: Run the Python Redis client w/ Redis server microservice example container:

Open a new terminal window.  

```
source run-python-autgen.sh
```

Wait a about 60 seconds and check APM Explore map to see the microservices.

Study the run scripts to understand how OpenTelemetry environment variables are configured, and the source code for the microservice example is [here](https://github.com/signalfx/otelworkshop/tree/main/k8s/python/tools/autogen)  

`ctrl-c` in each terminal will stop things and containers can be removed via standard Docker commands.

---
### Example 2: Python Microservice Sending Telmetry Directly to Splunk Observability Cloud  

Run the direct-to-ingest docker container:
```
source run-python-autogen-direct.sh 
```
Wait a about 60 seconds and check APM Explore map to see the microservices.

---
### Example 3: .NET Microservice Sending Telemetry Directly to Splunk Observability Cloud

Run the direct-to-ingest docker container:
```
source run-dotnet-autogen-direct.sh 
```
Wait a about 60 seconds and check APM Explore map to see the microservices.


### Misc

Docker container instructions for OpenTelemetry Collector are [here](https://github.com/signalfx/splunk-otel-collector/blob/main/docs/getting-started/linux-manual.md)

To test connectivity for tracing:  
```
curl -v -d'[]' -H'Content-Type:application/json' \
https://ingest.us1.signalfx.com/v2/trace
```