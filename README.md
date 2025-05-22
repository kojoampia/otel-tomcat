### Docker Network

- Run this docker network command to create a demonet network before your continue
```
docker network create demonet
```

- Then run docker compose to start the entire environment
``` 
docker compose -f otel-collector.yml -f docker-compose.yml up -d
``` 

Navigate to localhost:4300 to see open the demo app and generate some activity.

