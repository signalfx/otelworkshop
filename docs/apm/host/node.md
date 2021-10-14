# Single Host Node.js Lab

## Pre-Requisites

Make sure that you still have the Python Flask server from Python Lab running. If you accidentally shut it down follow steps from Python lab to restart the Python Flask server.

Make sure you are in the right directory to start the node.js activities:  

```bash
cd ~/otelworkshop/host/node
```

## Configure Node.js environment

```bash
npm init && \
npm install signalfx-tracing
```

During `npm init` you can use all defaults

## Configure HTTP.get requests

Set up environment and run the node app with HTTP.get requests

```bash
source run-client.sh
```

You will see requests printed to the window

## APM Dashboard

Traces / services will now be viewable in the APM dashboard. A new service takes about 90 seconds to register for the firs time, and then all data will be available in real time.

Additionally span IDs will print in the terminal where flask-server.py is running. You can use `ctrl-c` to stop the requests and server any time. You should now see a Node requests service alongside the Python and Java ones.  

![Node](../../assets/14-node.png)

![Node Traces](../../assets/15-nodetraces.png)

![Node Spans](../../assets/16-nodespans.png)

## Auto Instrumentation

For Node.js, the current auto-instrum
tation is based on OpenTracing from Splunk SignalFx. These spans are accepted by the OpenTelmetry Collector.

In `app.js` is a call to initiate an auto-instrumenting tracer from npm package `signalfx-tracing`

```nodejs
const tracer = require('signalfx-tracing').init()
```

This auto-instrumenting tracer must be added to the top of a Node app however no code changes are necessary.  

You can see in the `run-client.sh` how the environment has been set up for OpenTelemtry.

Splunk's autoinstrumentation for node.js is [here](https://github.com/signalfx/signalfx-nodejs-tracing)
