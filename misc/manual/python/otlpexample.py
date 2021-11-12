# Substitute YOURREALMHERE and YOURTOKENHERE 

# Requires
# pip3 install opentelemetry-api
# pip3 install opentelemetry-sdk
# pip3 install opentelemetry-exporter-otlp-proto-http

# tested with:
# opentelemetry-api                        1.7.1                           
# opentelemetry-sdk                        1.7.1               
# opentelemetry-semantic-conventions       0.26b1 
# opentelemetry-exporter-otlp              1.7.1
# opentelemetry-exporter-otlp-proto-grpc   1.7.1
# opentelemetry-exporter-otlp-proto-http   1.7.1


from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
# from opentelemetry.sdk.trace.export import ConsoleSpanExporter
import time

trace.set_tracer_provider(
    TracerProvider(
        resource=Resource.create({
            SERVICE_NAME: "manualtest/otlp-helloworld-svc"})
    )
)

otlp_exporter = OTLPSpanExporter(
    endpoint="https://ingest.YOURREALMHERE.signalfx.com/v2/trace/otlp",
    headers=(("x-sf-token", "SPLUNK_ACCESS_TOKEN_HERE"),)
)

trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(otlp_exporter)
)
while(True):
    tracer = trace.get_tracer(__name__)
    with tracer.start_as_current_span("foo"):
        with tracer.start_as_current_span("bar"):
            with tracer.start_as_current_span("baz"):
                print("Hello world from OpenTelemetry Python! CTRL-C to quit")
                time.sleep(.250)
trace.get_tracer_provider().shutdown()