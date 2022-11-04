# requires quay.io login
sudo docker build --load . -f dockerfile-splk-otel-python-autogen -t splk-python-autogen && \
sudo docker tag splk-python-autogen quay.io/vvydier123/splk-python-autogen && \
sudo docker push quay.io/vvydier123/splk-python-autogen
