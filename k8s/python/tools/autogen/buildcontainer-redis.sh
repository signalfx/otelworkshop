# requires quay.io login
sudo docker build --load . -f dockerfile-redis -t redis && \
sudo docker tag redis quay.io/vvydier123/redis && \
sudo docker push quay.io/vvydier123/redis
