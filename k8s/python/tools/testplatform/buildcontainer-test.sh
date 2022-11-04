# requires quay.io login
sudo docker build --load . -f dockerfile-test -t test-platform && \
sudo docker tag test-platform quay.io/vvydier123/test-platform && \
sudo docker push quay.io/vvydier123/test-platform
