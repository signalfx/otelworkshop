# Single Host Python Lab

Each step should be performed in a separate terminal window.

## Configure Environment

Set up environment and run Python Flask server using auto-instrumentation

```bash
cd ~/otelworkshop/host/python
source run-server.sh
```

You will see the server startup text when this is run.

## Run client application

Run the client python app via the `splk-py-trace` command to send requests to the Flask server. Open a new terminal window to your Linux instance and run the Python client to sent POST requests to the Flask server.

```bash
cd ~/otelworkshop/host/python
source run-client.sh
```

The `python-requests.py` client will make calls to the flask server with a random short sleep time.  
You can stop the requests with ++ctrl+c++

## Validate span are being sent

Check OpenTelemetry Collector Statistics to see that spans are being sent. Open a new terminal window to your Linux instance (or use `tmux` and run in separate pane)

`lynx localhost:55679/debug/tracez` will show the metrics and spans being gathered and sent by the Collector.  

Lynx is a text browser that was installed during with the `setup-tools`. Enabling a web browser to access your environment will allow for a full web GUI.  

![zpagaes](../../images/06-zpages.png)

## APM Dashboard

Traces / services will now be viewable in the APM dashboard. A new service takes about 90 seconds to register for the first time, and then all data will be available in real time.  
  
Additionally span IDs will print in the terminal where flask-server.py is running. You can use ++ctrl+c++ to stop the requests and server any time.  

Navigate to `Splunk Overvability -> APM`

![image](../../images/07-apm.png)

Service map of this python demo  

![image](../../images/08-python.png)

Click in the service dashboard requests and show sample traces, and then click the trace to see spans.

![image](../../images/09-pythontraces.png)  
![image](../../images/10-pythonspans.png)  

Click on Troubleshooting to see the map with latency, errors, etc. Try the Tag Spotlight view of Span Tags.

## Auto-Instrumentation

The `run-server.sh` and `run-client.sh` scripts set up the environment variables for OpenTelemetry and invoke the Python auto instrumentation:  

`splk-py-trace` is the auto instrumenting function that runs Python3 with the instrumentation that automatically emits spans from the Python app. No code changes are necessary. Splunk Observability Cloud has a `Getting Data In` Wizard to guide through instrumentation setup.

OpenTelemetry repo for Python is [here](https://github.com/signalfx/splunk-otel-python).

!!! important
    Leave the Flask server running you'll need need this process for the next client examples in the workshop.  