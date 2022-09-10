
---

`Splunk Observability -> Data Setup -> Linux`

Choose the following:

| Key | Value |
| ----- | ---- |
| **Access Token** | Select from list |
| **Mode** | Agent |
| **Log Collection** | No |  

Follow Data Setup Wizard for instructions on Linux installation:

![Data Setup](../../images/03-datasetup.png)

![Linux](../../images/04-datasetup-linux.png)

![Linux Install](../../images/05-datasetup-linuxinstall.png)

## Add in deployment.environment

Next we will add some metadata to the collector, so that any traces that go through the collector will have this attribute. (We could also apply this to the metrics and logs, but for this workshop we are only looking at tracing.)

Edit the file:
```
sudo nano /etc/otel/collector/agent_config.yaml
```

Use `Control-W` and type `deployment.environment<enter>` to find this section commented out

Make it look like the following, with the comments removed, and by replacing `INITIALS` with your own:
```
  resource/add_environment:
    attributes:
      - action: insert
        value: INITIALS-apm-workshop
        key: deployment.environment
```

**Important Note**: Watch the spacing! The `resource.environment` line is 2 spaces in, and all of the other sections are similarly indented. YAML is very sensitive to spacing.

Now let's search for the word `pipelines` (using `Control-W`). Here we can see all of the out of the box pipelines for metrics, traces and logs. Note that in the tracing pipeline the `resources/add_environment` is commented out. Let's uncomment it so it looks like this:
```
service:
  extensions: [health_check, http_forwarder, zpages, memory_ballast]
  pipelines:
    traces:
      receivers: [jaeger, otlp, smartagent/signalfx-forwarder, zipkin]
      processors:
      - memory_limiter
      - batch
      - resourcedetection
      - resource/add_environment
```

You are now finished editing so hit `Control-O`, then `y` to save, and then `<enter>` to save as the same name.

We can restart the collector so it takes our changes:

```
sudo systemctl restart splunk-otel-collector
```

And to make sure it started fine:
```
sudo systemctl status splunk-otel-collector
```

It should output something like:

```
● splunk-otel-collector.service - Splunk OpenTelemetry Collector
     Loaded: loaded (/lib/systemd/system/splunk-otel-collector.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/splunk-otel-collector.service.d
             └─service-owner.conf
     Active: active (running) since Sun 2021-10-31 13:07:27 UTC; 1min 11s ago
   Main PID: 37949 (otelcol)
      Tasks: 9 (limit: 19200)
     Memory: 100.2M
     CGroup: /system.slice/splunk-otel-collector.service
             └─37949 /usr/bin/otelcol

Oct 31 13:07:27 ip-172-31-70-180 otelcol[37949]: 2021-10-31T13:07:27.556Z        info        builder/receivers_builder.go:73  >
Oct 31 13:07:27 ip-172-31-70-180 otelcol[37949]: 2021-10-31T13:07:27.556Z        info        builder/receivers_builder.go:68  >
Oct 31 13:07:27 ip-172-31-70-180 otelcol[37949]: 2021-10-31T13:07:27.556Z        info        builder/receivers_builder.go:73  >
Oct 31 13:07:27 ip-172-31-70-180 otelcol[37949]: 2021-10-31T13:07:27.556Z        info        healthcheck/handler.go:129       >
Oct 31 13:07:27 ip-172-31-70-180 otelcol[37949]: 2021-10-31T13:07:27.556Z        info        service/telemetry.go:92        Se>
Oct 31 13:07:27 ip-172-31-70-180 otelcol[37949]: 2021-10-31T13:07:27.557Z        info        service/telemetry.go:116        S>
Oct 31 13:07:27 ip-172-31-70-180 otelcol[37949]: 2021-10-31T13:07:27.557Z        info        service/collector.go:230        S>
Oct 31 13:07:27 ip-172-31-70-180 otelcol[37949]: 2021-10-31T13:07:27.557Z        info        service/collector.go:132        E>
Oct 31 13:07:37 ip-172-31-70-180 otelcol[37949]: 2021-10-31T13:07:37.826Z        info        hostmetadata/metadata.go:75      >
Oct 31 13:07:37 ip-172-31-70-180 otelcol[37949]: 2021-10-31T13:07:37.826Z        info        hostmetadata/metadata.go:83      >
```

Your machine will be visible in Splunk Observability in `Infrastructure` either in the public cloud platform you are using or `My Data Center` if you are using Multipass or any other non public cloud machine.
