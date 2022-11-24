We will now look at APM from the perspective of the same applications running in a Kubernetes-orchestrated environment.
 

> <ins>If using your own k8s cluster on an Ubuntu host</ins>  
> Remove the Otel Collector if its running on the same host as your k8s cluster:
> ```bash
> sudo sh /tmp/splunk-otel-collector.sh --uninstall
> ```
> Use this setup script to bootstrap your Debian based k8s environment with everything needed for the k8s workshop:  
```
bash <(curl -s https://raw.githubusercontent.com/signalfx/otelworkshop/master/setup-tools/k8s-env-only.sh)
```
> Ensure you have `helm` and `lynx` installed.  
>  
> Skip to: **2: Deploy APM for containerized apps: Python and Java**  
> If you are using k8s anywhere else you can still do this workshop but will need to ensure `helm`, `lynx` are available.

---
### Step 0: Stop the previous Host-based applications and remove the Host-based Otel Collector
If you have worked through the previous steps in this workshop by deploying Host-based instances of the Python, Java and Node applications, they will need to be terminated before working though this section of the workshop.

#### Stop the previous instances of the applications
Stop all the prior labs apps by using `ctrl-c` in each terminal window and then closing each window.

#### Remove the host based otel collector:
`sudo sh /tmp/splunk-otel-collector.sh --uninstall`

### Step 1: Use Data Setup Wizard for Splunk Otel Collector Pod on k3s

Identify your token and realm from the Splunk Observability Cloud Portal:   
`Organization Settings->Access Tokens` and `Your Name->Account Settings`

Export both of these values as environment variables in your current shell.

```bash
export ACCESS_TOKEN=<your access token value>
export REALM=<your Splunk Observability Cloud realm>
```

#### 1a: Splunk Observability Cloud Portal
 
In Splunk Observability Cloud: `Data Setup->Kubernetes->Add Connection`  

<img src="../../images/17-datasetup-k8s.png" width="360">  

Choose the following:

| Key | Value |
| ----- | ---- |
| Access Token | Select from list |
| Cluster Name | Your initials-cluster i.e. SL-cluster |
| Provider | Other |
| Distribution | Other |
| Add Gateway | No |
| Log Collection | True |
| Profiling | False |  

And then select `Next`  

Follow the steps on the `Install Integration` page.

<img src="../../images/18-datasetup-k8sinstall.png" width="360"> 

A result will look like this:  
```
NAME: splunk-otel-collector-1620505665
LAST DEPLOYED: Sat May  8 20:27:46 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

Note the name of the deployment when the install completes i.e.:   `splunk-otel-collector-1620505665`  

#### 1b: Update k3s For Splunk Log Observer (*Ignore if you are using your own non-K3s Kubernetes cluster*)

K3s has a different log format than standard k8s. We need to update our deployment to correctly parse K3s log format.

##### Get Helm package name
You'll need the Collector deployment name from the Data Setup Wizard installation steps. You can also derive this from using `helm list` i.e.:  
```
NAME                                    NAMESPACE       REVISION        UPDATED                                 STATUS       CHART                           APP VERSION
splunk-otel-collector-1620504591        default         1               2021-05-08 20:09:51.625419479 +0000 UTC deployed     splunk-otel-collector-0.25.0  
```
The deployment name would be: `splunk-otel-collector-1620504591`  

##### Prepare values for Collector update  

If you run into any errors from helm, fix with:  
```
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
sudo chmod 755 /etc/rancher/k3s/k3s.yaml
```

Prep values for collector update:  

```
helm list
helm get values NAME
```

For example:
```
helm get values splunk-otel-collector-1620609739
```

You can see the values we set at install time.

##### Prepare values.yaml file for updating the Helm chart
There are some minor changes to the OpenTelemetry Collector deployment configuration that will all

Start in k8s directory:
```bash
cd ~/otelworkshop/k8s
```

Run ```cat k3slogs.yaml```. You can see that we want to make some additional changes to logging with fluentd.

##### Update the Collector 

Install the Collector configuration chart; be sure to change ```YOURCOLLECTORHERE``` with the ```NAME``` from above:  

```
helm upgrade \
YOURCOLLECTORHERE \
--values k3slogs.yaml \
splunk-otel-collector-chart/splunk-otel-collector \
--reuse-values
```

i.e.

```
helm upgrade \
splunk-otel-collector-1620609739 \
--values k3slogs.yaml \
splunk-otel-collector-chart/splunk-otel-collector \
--reuse-values
```

You can now check your values again:
```
helm get values YOURCOLLECTORHERE
```
and you should see both your default install information (like tokens and realm) and the new logging configuration are available.

#### 1c Update your Collector configuration for your own APM Environment Tag
Similar to the Host-based deployment process, we will add our own custom environment tag to the Collector configuration.  This will tag all spans coming into the Collector with a specific environment name, allowing you to see APM data specific to your workshop setup.  

If you are running applications in clusters that span environments (for example “dev” and “prod”) you might want to set the environment value from the application itself.  The flexibility of OpenTelemetry lets you tailor your telemetry data to meet a wide variety of deployment models.

##### Supply Your Environment Name
We can execute a short Linux command to replace all instances of the string <ENV PREFIX> with your own environment prefix value.  This helps isolate your workshop resources from others.


Included is a helpful command to cover all the necessary files at once.  Pick a short alphanumeric string to prefix your Environment. The pattern of the command looks like:
```bash
grep -RiIl '<ENV PREFIX>' | xargs sed -i 's/<ENV PREFIX>/<choose-your-own-prefix>/g'
```
Replace the `<choose-your-own-prefix>` with an arbitrary value of your choosing, omitting the `<` and `>` characters.


If you choose `foo`, for example, execute the following commands:
```bash
cd ~/otelworkshop/k8s
grep -RiIl '<ENV PREFIX>' | xargs sed -i 's/<ENV PREFIX>/foo/g'
```
As an alternative, you can manually edit the files using Nano (or Vim).  This example uses Nano.

Open the `resource-environment.yaml` file
```bash
cd ~/otelworkshop/k8s/
nano resource-environment.yaml
```
Edit the contents by replacing the placeholder text:
```yaml
agent:
  config:
    processors:
      resource/add_environment:
        attributes:
          - action: insert
            value: <ENV PREFIX>-apm-workshop <------ Replace with your initials
            key: deployment.environment
    service:
      pipelines:
        traces:
          processors:
            - memory_limiter
            - batch
            - resourcedetection
            - resource/add_environment
```
##### Apply the Resource Environment Collector Config to The Collector Pods
Execute the following command to update your Collector config.  Make sure to substitute your specific Helm installation name found from `helm list`.
```bash
helm upgrade <splunk-otel-collector-deployment-name> --values resource-environment.yaml splunk-otel-collector-chart/splunk-otel-collector --reuse-values
```

---
### 2: Deploy APM For Containerized Apps: Python and Java

Deploy the Flask server deployment/service and the python-requests (makes requests of Flask server) pod:  
```
cd ~/otelworkshop/k8s
kubectl apply -f py-deployment.yaml
```

Deploy the Java OKHTTP requests pod (makes requests of Flask server):  
```
kubectl apply -f java-deployment.yaml
```
Study the results:

The APM Dashboard will show the instrumented Python-Requests and Java OKHTTP clients posting to the Flask Server.  
Make sure you select the `xxx-apm-workshop` ENVIRONMENT to monitor.

<img src="../../images/19-k8s-apm.png" width="360">  

Study the `deployment.yaml` files:

Example in Github or:  
```
~/otelworkshop/k8s/py-deployment.yaml   
~/otelworkshop/k8s/java-deployment.yaml   
```
The `*.yaml` files show the environment variables telling the instrumentation to send spans to the OpenTelemetry Collector.

Normally we use an environment variable pointing to `localhost` on a single host application where the Collector is running. In k8s we have separate pods in a cluster for apps and the Collector.   

The Collector pod is running with <ins>node wide visibility</ins>, so to tell each application pod where to send spans:

```
- name: SPLUNK_OTEL_AGENT
  valueFrom:
    fieldRef:
      fieldPath: status.hostIP
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: "http://$(SPLUNK_OTEL_AGENT):4317"
```

---
### 3: Monitor JVM Metrics For a Java Container

JVM Metrics are emitted by the Splunk OpenTelemetry Java instrumentation and send to the Collector.  
 
Download this file to your local machine: [JVM Metrics Dashboard Template](https://raw.githubusercontent.com/signalfx/otelworkshop/master/k8s/dashboard_JVMMetrics.json)  

Select the + Icon on top right and create a new **Dashboard Group** called `test`  

Click the + Icon again and select `Import->Dahsboard`  
and select the downloaded `dashboard_JVMMetrics.json` file.   

<img src="../../images/27-jvm.png" width="360">    

Filter by Application by adding `service:SERVICENAMEHERE`  

<img src="../../images/28-jvm-filter.png" width="360">    

Complete JVM metrics available [at this link](https://github.com/signalfx/splunk-otel-java/blob/main/docs/metrics.md#jvm)

---
### 4:  Manually instrument a Java App And Add Custom Attributres (Tags)

Let's say you have an app that has your own functions and doesn't only use auto-instrumented frameworks- or doesn't have any of them!  

You can easily manually instrument your functions and have them appear as part of a service, or as an entire service.

Example is here:

`cd ~/otelworkshop/k8s/java/manual-inst`  

Deploy an app with ONLY manual instrumentation:  

```
kubectl apply -f java-reqs-manual-inst.yaml
```

When this app deploys, it appears as an isolated bubble in the map. It has all metrics and tracing just like an auto-instrumented app does. 

<img src="../../images/20-k8s-manual.png" width="360">  

Take a look at the traces and their spans to see the manually added values of Message, Logs etc.

<img src="../../images/21-k8s-m-trace.png" width="360">  

You will see the function called ExampleSpan with custom `Logging` messages and a `message:myevent` span/tag.  

<img src="../../images/22-k8s-m-span1.png" width="360">  

<img src="../../images/23-k8s-m-span2.png" width="360">  

See the custom attribute `my.key` and value `myvalue`.  
This could be a transaction ID, user ID, or any custom value that you want to correlate and even metricize.  

<img src="../../images/23-k8s-m-span3.png" width="360">  

Study the [manual instrumentation code example here.](https://github.com/signalfx/otelworkshop/blob/master/k8s/java/manual-inst/src/main/java/sf/main/GetExample.java)

There are two methods shown- the decorator @WithSpan method (easiest), and using the GlobalTracer method (more complicated/powerful)...

Note that this is the most minimal example of manual instrumentation- there is a vast amount of power available in OpenTelemetry- please see [the documentation](https://github.com/open-telemetry/opentelemetry-java-instrumentation) and [in depth details](https://github.com/open-telemetry/opentelemetry-java/blob/master/QUICKSTART.md#tracing)

---
### 5: Process Spans with the Otel Collector

The Otel Collector has many powerful configuration options ranging from splitting telemetry to multiple destinations to sampling to span processing.  

[Processor documentation](https://github.com/open-telemetry/opentelemetry-collector/tree/main/processor)  

[Collector config examples](https://github.com/signalfx/splunk-otel-collector-chart/tree/main/examples)  

[Full documentation](https://github.com/signalfx/splunk-otel-collector)  

#### Prepare values for Collector update

```
helm list
```
```
helm get values NAME
```

i.e. `helm get values splunk-otel-collector-1620609739`

make note of:  
`clusterNAME`  
`splunkAccessToken`  
`splunkRealm`  

#### Span Processing Example: Redacting Data from a Span Attribute

Change to the example directory:
```
cd ~/otelworkshop/k8s/collectorconfig
```

#### Prepare values.yaml file for updating the Helm chart  

Edit `spanprocessor.yaml` with the values from Step 1.  

#### Update the Collector 

Install the Collector configuration chart:  

```
helm upgrade --install \ 
YOURCOLLECTORHERE \
--values spanprocessor.yaml \
splunk-otel-collector-chart/splunk-otel-collector
```

i.e.

```
helm upgrade --install \
splunk-otel-collector-1620609739 \
--values spanprocessor.yaml \
splunk-otel-collector-chart/splunk-otel-collector
```

Study the results:  

`Splunk Observability Portal -> APM -> Explore -> java-otel-manual-inst -> Traces`

Example `my.key` and you'll see that the value is `redacted` after applying the `spanprocessor.yaml` example

<img src="../../images/25-span-redacted.png" width="360">  

If you want to make changes and update the `spanprocessor.yaml` or add more configurations, use:  
`helm upgrade --reuse-values`

---
### 6: Receive Prometheus Metrics at the Otel Collector

#### Add a Prometheus endpoint pod  

Change to the k8s Collector Config directory:  
```
cd ~/otelworkshop/k8s/collectorconfig
```

Add the Prometheus pod (source code is in the `k8s/python` directory):
```
kubectl apply -f prometheus-deployment.yaml
```

#### Update Otel Collector to Scrape the Prometheus Pod

Update realm/token/cluster in the `otel-prometheus.yaml`  

Verify your helm deployment of the collector:

```
helm list
```

Upgrade the Collector deployment with the values required for scraping Prometheus metrics from the Prometheus pod deployed in the previous step:

```
helm upgrade --reuse-values splunk-otel-collector-YOURCOLLECTORVALUE --values otel-prometheus.yaml splunk-otel-collector-chart/splunk-otel-collector
```

#### Find Prometheus Metric and Generate Chart

`Splunk Observabilty -> Menu -> Metrics -> Metric Finder`  

Search for: `customgauge`  

Click `CustomGauge`  

Chart appears with value `17`

Examine the collector update `otel-prometheus.yaml` to see how this works.

---
### 7: Configure Otel Collector to Transform a Metric Name

This example uses the [Metrics Transform Processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/metricstransformprocessor)  

Change to the k8s Collector Config directory:  
```
cd ~/otelworkshop/k8s/collectorconfig
```
Update realm/token/cluster in the `metricstransform.yaml` with your token/realm/cluster  

Upgrade the Collector deployment with the values required for scraping Prometheus metrics from the Prometheus pod deployed in the previous step:

```
helm upgrade --reuse-values splunk-otel-collector-YOURCOLLECTORVALUE --values metricstransform.yaml splunk-otel-collector-chart/splunk-otel-collector
```

#### Find Transformed Prometheus Metric and Generate Chart

`Splunk Observabilty -> Menu -> Metrics -> Metric Finder`  

Search for: `transformedgauge`  

Click `TransformedGauge`  

You'll now see the new chart for the metric formerly known as CustomGauge that has been transformed using the metrics transform processor.  

Examine the collector update `metricstransform.yaml` to see how this works.

---
### Monitoring and Troubleshooting  

#### View Otel Collector POD stats

```
kubectl get pods
```

Note the pod name of the `OpenTelemetry Collector` pod i.e.:  
`splunk-otel-collector-1620505665-agent-sw45w`

Send the Zpages stats to the lynx browser:  
```
kubectl exec -it YOURAGENTPODHERE -- curl 127.0.0.1:55679/debug/tracez | lynx -stdin
```  
i.e.
```
kubectl exec -it splunk-otel-collector-1620505665-agent-sw45w -- curl 127.0.0.1:55679/debug/tracez | lynx -stdin
```

<img src="../../images/06-zpages.png" width="360"> 

#### Examine Otel Collector Config

get your Collector agent pod name via:
```
kubectl get pods
```

i.e.

`splunk-otel-collector-1626453714-agent-vfr7s` 

Show current Collector config:  
```
kubectl exec -it YOURAGENTPODHERE -- curl 127.0.0.1:55554/debug/configz/effective
```

Show initial Collector config:  
```
kubectl exec -it YOURAGENTPODHERE -- curl 127.0.0.1:55554/debug/configz/initial
```

---
### Bonus Instrumentation Examples: Istio and .NET

#### .NET: containerized example is [located here](dotnet.md)  
#### Istio: service mesh [lab here](istio.md)

---
### Clean up deployments and services

To delete all k8s lab work:  
in `~/otelworkshop/k8s/`  
```
source delete-all-k8s.sh
source delete-prometheus.sh
```

To delete the Collector from k8s:  
```
helm list
```  
`helm delete YOURCOLLECTORHERE`
i.e.
```
helm delete splunk-otel-collector-1620505665
```

k3s:
```
/usr/local/bin/k3s-uninstall.sh
```