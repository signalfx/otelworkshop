docker run --rm -dit \
-e SIGNALFX_SERVICE_NAME=dotnet-autogen-debug \
-e SIGNALFX_ENDPOINT_URL=otelcol:9411/api/v2/spans \
-e SIGNALFX_TRACE_GLOBAL_TAGS=deployment.environment:apm-workshop \
-e CORECLR_ENABLE_PROFILING=1 \
-e CORECLR_PROFILER="'{B4C89B0F-9908-4F73-9F59-0D77C5A06874}'" \
-e CORECLR_PROFILER_PATH=/opt/signalfx-dotnet-tracing/SignalFx.Tracing.ClrProfiler.Native.so \
-e SIGNALFX_INTEGRATIONS=/opt/signalfx-dotnet-tracing/integrations.json \
-e SIGNALFX_DOTNET_TRACER_HOME=/opt/signalfx-dotnet-tracing \
-e SIGNALFX_TRACE_DEBUG=true \
-e SIGNALFX_TRACE_LOG_PATH=/opt/tracelogs \
-e SIGNALFX_STDOUT_LOG_ENABLED=1 \
--network otel-net \
--name dotnet-autogen docker.io/stevelsplunk/splk-dotnet5

docker exec -it dotnet-autogen /bin/sh /App/run-client.sh