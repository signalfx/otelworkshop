# requires quay.io login
sudo docker build --load . -f splk-otel-python.dockerfile -t splk-python && \
sudo docker tag splk-python quay.io/vvydier123/splk-python && \
sudo docker push quay.io/vvydier123/splk-python
