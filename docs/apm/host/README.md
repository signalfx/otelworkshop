##  Lab 1: Set up Splunk OpenTelemetry Collector Agent on your host

### Step 1: Install Otel Collector Agent on your Ubuntu host

`Splunk Obervability -> Data Setup -> Linux`  

Choose the following:
| Key | Value |
| ----- | ---- |
| Access Token | Select from list |
| Mode | Agent |
| Log Collection | No |  

Follow Data Setup Wizard for instructions on Linux installation:

<img src="../assets/03-datasetup.png" width="360" />  

<img src="../assets/04-datasetup-linux.png" width="360" />  

<img src="../assets/05-datasetup-linuxinstall.png" width="360" />

### Step 2: APM Instrumentation for Python

[Python: traces from Flask server and Python requests client](../python)

### Step 3: APM Instrumentation for Java
[Java: traces from OKHTTP client](../java)

### Step 4: APM Instrumentation for Node
[Node: traces Node HTTP.get client](../node)