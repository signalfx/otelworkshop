# APM for Single Host

## 1: Install Otel Collector Agent on your Ubuntu host

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

## 2: Python

[Python: traces from Flask server and Python requests client](python.md)

## 3: Java

[Java: traces from OKHTTP client](java.md)

## 4: Node

[Node.js: traces Node HTTP.get client](node.md)