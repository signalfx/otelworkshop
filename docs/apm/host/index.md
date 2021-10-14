# APM for Single Host

## 1: Install Otel Collector

`Splunk Obervability -> Data Setup -> Linux`  

Choose the following:

| Key | Value |
| ----- | ---- |
| **Access Token** | Select from list |
| **Mode** | Agent |
| **Log Collection** | No |  

Follow Data Setup Wizard for instructions on Linux installation:

![Data Setup](../assets/03-datasetup.png)

![Linux](../assets/04-datasetup-linux.png)

![Linux Install](../assets/05-datasetup-linuxinstall.png)


[Python: traces from Flask server and Python requests client](python.md)

[Java: traces from OKHTTP client](java.md)

[Node.js: traces Node HTTP.get client](node.md)