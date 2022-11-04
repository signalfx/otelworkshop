# requires dockerhub login
curl -L https://github.com/signalfx/splunk-otel-java/releases/latest/download/splunk-otel-javaagent-all.jar -o ./splunk-otel-javaagent.jar
sudo docker build . -f dockerfile-java -t splk-java
sudo docker tag splk-java quay.io/vvydier123/splk-java
sudo docker push quay.io/vvydier123/splk-java
rm ./splunk-otel-javaagent.jar
