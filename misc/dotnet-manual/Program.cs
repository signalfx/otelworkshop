using OpenTelemetry;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using System;
using System.Diagnostics;
using System.Threading.Tasks;

namespace Sample.DistributedTracing
{
    class Program
    {
        static ActivitySource s_source = new ActivitySource("Sample.DistributedTracing");

        public static async Task Main()
                {
                    while(true)
                    {
                        using var tracerProvider = Sdk.CreateTracerProviderBuilder()
                            .SetResourceBuilder(ResourceBuilder.CreateDefault().AddService("MySample"))
                            .AddSource("Sample.DistributedTracing")
                            .AddConsoleExporter()
                            .AddOtlpExporter()
                            .Build();

                        await DoSomeWork();
                        Console.WriteLine("Example work done");
                    }
                }

        static async Task DoSomeWork()
        {
            using (Activity a = s_source.StartActivity("SomeWork"))
            {
                await StepOne();
                await StepTwo();
            }
        }

        static async Task StepOne()
        {
            using (Activity a = s_source.StartActivity("StepOne"))
            {
                await Task.Delay(250);
            }
        }

        static async Task StepTwo()
        {
            using (Activity a = s_source.StartActivity("StepTwo"))
            {
                await Task.Delay(250);
            }
        }
    }
}