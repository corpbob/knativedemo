set -x
#ab -c 1 -H "Host: event-greeter.knativedemo.example.com" http://104.225.222.173:31396/
siege -r 1 -c 50 -t 30S \
  -H "Host: greeter.knativedemo.example.com" \
  "http://104.225.222.173:31396"
#"Host: greeter.knativedemo.example.com" http://104.225.222.173:31396
