.NET CORE example uses the .NET http client to get non-responding URL so makes valid traces with 403 status code

Containerized with these [instructions from Microsoft](https://docs.microsoft.com/en-us/dotnet/core/docker/build-container?tabs=windows)

**.NET Core 5** 
Deploy:  
```
source deploy-client.sh
```

Delete deployment:
```
source delete-all.sh
```

**.NET Core 2.1** 
.NET Core 2.1 [located here](../../misc/dotnet-2.1)

[Click here to return to k8s APM labs](../README.md)