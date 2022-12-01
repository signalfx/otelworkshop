# requires dockerhub login
curl -L https://github.com/signalfx/splunk-otel-java/releases/latest/download/splunk-otel-javaagent-all.jar -o ./splunk-otel-javaagent.jar
sudo docker build --load . -f dockerfile-java-autogen -t splk-java-autogen
sudo docker tag splk-java-autogen quay.io/vvydier123/splk-java-autogen
sudo docker push quay.io/vvydier123/splk-java-autogen
rm ./splunk-otel-javaagent.jar
