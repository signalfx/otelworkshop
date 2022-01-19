FROM mcr.microsoft.com/dotnet/aspnet:5.0
COPY bin/Release/net5.0/publish/ App/
COPY *.deb App/
COPY run-client.sh /App
WORKDIR /App
RUN dpkg -i *.deb