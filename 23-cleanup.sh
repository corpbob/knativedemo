set -x
oc delete -f 21-event-source.yaml
oc delete -f 22-channel-subscriber.yaml
oc delete -f 20-channel.yaml
oc delete -f 19-deploy-sink-service.yaml
