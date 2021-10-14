# Single Host Java Lab

Each step should be performed in a separate terminal window.

## Prerequisites

Make sure that you still have the Python Flask server from the Python Lab running. If you accidentally shut it down follow steps from Workshop #2 to restart the Python Flask server.

Make sure you are in the right directory to start the Java activities:  

```bash
cd ~/otelworkshop/host/java
```

## Download Otel Java Instrumentation

Download Splunk OpenTelemetry Java Auto-instrumentation to `/opt`

```bash
source install-java-otel.sh
```

## Run the Java HTTP requests client

Run the Java example with OKHTTP requests:

```bash
source run-client.sh
```

You will see requests printed to the window.

## APM Dashboard

Traces/services will now be viewable in the APM dashboard. A new service takes about 90 seconds to register for the first time, the Python and n all data will be available in real time.  

Additionally the requests made by Java will print in the terminal where flask-server.py is running. You can use ++ctrl+c++ to stop the requests and server any time.

You should now see a new Java requests service alongside the Python one.

![Java](../../images/11-java.png)

![Java Traces](../../images/12-javatraces.png)

![Java Spans](../../images/13-javaspans.png)

## Auto-instrumentation

In the `run-client.sh` script the java command:

```bash
java \
-Dexec.executable="java" \
-Dotel.resource.attributes=service.name=java-otel-client,deployment.environment=apm-workshop \
-Dotel.exporter.otlp.endpoint=http://127.0.0.1:4317 \
-Dsplunk.metrics.endpoint=http://127.0.0.1:9943 \
-javaagent:/opt/splunk-otel-javaagent.jar \
-jar ./target/java-app-1.0-SNAPSHOT.jar
```

The `splunk-otel-javaagent.jar` file is the automatic OpenTelemetry instrumentation that will emit spans from the app. No code changes are necessary! The `otel.` resources set up the service name, environment, and destination to send the JVM metrics and spans.

Splunk's OpenTelmetry autoinstrumentation for Java is [here](https://github.com/signalfx/splunk-otel-java)