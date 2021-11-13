# Substitute YOURREALMHERE and YOURTOKENHERE 

# Requires
# pip3 install opentelemetry-api
# pip3 install opentelemetry-sdk
# pip3 install opentelemetry-exporter-jaeger
# pip3 install keyboard

# tested with:
# opentelemetry-api                        1.7.1               
# opentelemetry-exporter-jaeger            1.7.1               
# opentelemetry-exporter-jaeger-proto-grpc 1.7.1               
# opentelemetry-exporter-jaeger-thrift     1.7.1               
# opentelemetry-sdk                        1.7.1               
# opentelemetry-semantic-conventions       0.26b1 

from opentelemetry import trace
from opentelemetry.exporter.jaeger.thrift import JaegerExporter
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
# from opentelemetry.sdk.trace.export import ConsoleSpanExporter
import time

trace.set_tracer_provider(
    TracerProvider(
        resource=Resource.create({
            SERVICE_NAME: "manualtest/jaeger-helloworld-svc"})
    )
)

jaeger_exporter = JaegerExporter(
    collector_endpoint="https://ingest.YOURREALMHERE.signalfx.com/v2/trace",
    username="auth",
    password="YOURTOKENHERE"
)

trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(jaeger_exporter)
)
while(True):
    tracer = trace.get_tracer(__name__)
    with tracer.start_as_current_span("foo"):
        with tracer.start_as_current_span("bar"):
            with tracer.start_as_current_span("baz"):
                print("Hello world from OpenTelemetry Python! CTRL-C to quit")
                time.sleep(.250)
# trace.get_tracer_provider().shutdown()