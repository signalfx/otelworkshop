FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /App

# Copy everything
COPY . ./
# Add signalfx-dotnet-tracing
RUN mkdir /opt/signalfx-dotnet-tracing
RUN mkdir /opt/tracelogs
RUN tar -xf signalfx-dotnet-tracing-0.2.9.tar.gz -C /opt/signalfx-dotnet-tracing
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /App
COPY --from=build-env /App/out .
ENTRYPOINT ["dotnet", "myApp.dll"]

