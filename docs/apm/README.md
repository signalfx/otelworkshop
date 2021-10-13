### Splunk Observability OpenTelemetry Workshop

#### Step 1: [Pre-work: Choose/Prepare Your Sandbox Environment and Review Key Concepts](./workshop-steps/1-prep.md)  

#### Step 2: [Install Splunk OpenTelemetry Collector Agent on an Ubuntu host](./workshop-steps/2-otelagent.md)  

#### Step 3: [Complete APM Workshop Labs for Hosts / k8s ](./workshop-steps/3-workshop-labs.md)  
APM for Kubernetes Lab only: [start here](./k8s)  

#### Non Kubernetes container examples:  
[AWS ECS: EC2/Fargate](misc)

### Document Conventions

Variables from your Splunk Observability account are displayed like this: YOURVARIABLEHERE.   
I.e. to change your REALM to `us1` change `api.YOURREALMHERE.signalfx.com` to `api.us1.signalfx.com`  

- k8s = Kubernetes
- k3s = a lightweight Kubernetes from Rancher (https://www.k3s.io)
- signalfx = Splunk Observability domain name/endpoint/technology name
- otel = OpenTelemetry