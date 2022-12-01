# requires quay.io login
sudo docker build --load . -f dotnet.dockerfile -t splk-dotnet6 && \
sudo docker tag splk-dotnet6 quay.io/vvydier123/splk-dotnet6 && \
sudo docker push quay.io/vvydier123/splk-dotnet6
