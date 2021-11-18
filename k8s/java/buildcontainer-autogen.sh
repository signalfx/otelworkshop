# requires dockerhub login
curl -L https://github.com/signalfx/splunk-otel-java/releases/latest/download/splunk-otel-javaagent-all.jar -o ./splunk-otel-javaagent.jar
sudo docker build . -f dockerfile-java-autogen -t splk-java-autogen
sudo docker tag splk-java-autogen stevelsplunk/splk-java-autogen
sudo docker push stevelsplunk/splk-java-autogen
rm ./splunk-otel-javaagent.jar