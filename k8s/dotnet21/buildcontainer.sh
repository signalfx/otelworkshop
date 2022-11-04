# requires quay.io login
sudo docker build --load . -f dotnet-3.1.dockerfile -t splk-dotnet-3.1 && \
sudo docker tag splk-dotnet-3.1 quay.io/vvydier123/splk-dotnet-3.1 && \
sudo docker push quay.io/vvydier123/splk-dotnet-3.1
