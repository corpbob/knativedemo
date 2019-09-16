kubectl get rev -l serving.knative.dev/configuration=greeter --sort-by="{.metadata.creationTimestamp}"
