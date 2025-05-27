### Demo OpenTelemetry Tomcat Java Application
This project demonstrates how to instrument a Java application running on Apache Tomcat with OpenTelemetry. It includes a simple web application that generates traces and metrics, which are then collected by an OpenTelemetry Collector.
### Prerequisites
- Docker installed on your machine
- Docker Compose installed on your machine
- Basic understanding of Docker and Docker Compose
- Java Development Kit (JDK) installed (for building the project)
### Project Structure
```
otel-tomcat/
├── app
│   └── src
│       └── main
│           └── resources
│               └── application.properties
│           └── java
│               └── net
│                   └── jojoaddison
│                       └── app
│                           └── Application.java
|   └── pom.xml
│   ├── .git 
│   ├── .gitignore
│   ├── .mvn
│   │   └── wrapper
│   ├── mvnw
│   └── mvnw.cmd
├── Dockerfile
├── docker-compose.yml
├── otel-collector.yml
└── README.md
```
### Build the Project
1. Navigate to the project directory:
   ```bash
   cd otel-tomcat
   ```
2. Build the project using Maven:
   ```bash
   mvn clean package
   ```
### Dockerfile
```dockerfile
FROM openjdk:11-jre-slim
COPY target/demo-otel-tomcat.jar /app/demo-otel-tomcat.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/demo-otel-tomcat.jar"]
```
### Docker Compose
```yaml
version: '3.8'
services:
  demo-otel-tomcat:
    build: .
    ports:
      - "8080:8080"
    networks:
      - demonet
    environment:
      - OTEL_SERVICE_NAME=demo-otel-tomcat
      - OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317
      - OTEL_RESOURCE_ATTRIBUTES=service.name=demo-otel-tomcat
  otel-collector:
    image: otel/opentelemetry-collector:latest
    ports:
      - "4317:4317"
      - "55681:55681"
    networks:
      - demonet
    command: ["--config", "/etc/otel-collector-config.yaml"]
    volumes:
      - ./otel-collector.yml:/etc/otel-collector-config.yaml
networks:
  demonet:
    driver: bridge
```
### OpenTelemetry Collector Configuration
```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 
        http:
          endpoint: "http://localhost:4317"
exporters:
  logging:
    loglevel: debug
  otlp:
    endpoint: "otel-collector:4317"
    tls:
      insecure: true
processors:
  batch:
    timeout: 5s
    send_batch_size: 1024
service:
  pipelines:
    traces:
      receivers: [otlp]
      exporters: [logging, otlp]
    metrics:
      receivers: [otlp]
      exporters: [logging, otlp]
```
### Running the Project
1. Ensure Docker is running on your machine.
2. Build the Docker image:
   ```bash
   docker build -t demo-otel-tomcat .
   ```
3. Create a Docker network:
   ```bash
   docker network create demonet
   ```
4. Start the environment using Docker Compose:
   ```bash
   docker compose -f otel-collector.yml -f docker-compose.yml up -d
   ```
5. Open your web browser and navigate to `http://localhost:8080` to access the demo application.

### Instructions to Run the Project
1. **Navigate to the project directory**:
   ```bash
   cd otel-tomcat
   ```
2. **Build the project using Maven**:
   ```bash
   mvn clean package
   ```
3. **Build the Docker image**:
   ```bash
   docker build -t demo-otel-tomcat .
   ```
4. **Create a Docker network**:
   ```bash
   docker network create demonet
   ```
5. **Start the environment using Docker Compose**:
   ```bash
   docker compose -f otel-collector.yml -f docker-compose.yml up -d
   ```
6. **Access the demo application**:
   Open your web browser and navigate to `http://localhost:8080`.
### Stopping the Project
To stop the project, run the following command in the project directory:
```bash
docker compose -f otel-collector.yml -f docker-compose.yml down
```
### Troubleshooting
If you encounter any issues, check the following:
- Ensure Docker and Docker Compose are installed and running.
- Verify that the Docker network `demonet` is created successfully.
- Check the logs of the OpenTelemetry Collector and the demo application for any errors:
  ```bash
  docker compose logs demo-otel-tomcat
  docker compose logs otel-collector
  ```
### Additional Resources
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
- [Apache Tomcat Documentation](https://tomcat.apache.org/)
- [Docker Documentation](https://docs.docker.com/)
### License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
### Contributing
Contributions are welcome! If you have suggestions for improvements or find bugs, please open an issue or submit a pull request.
### Version
This project is currently at version 1.0.0. Future updates will be documented in the CHANGELOG file.
### Change Log
- **1.0.0**: Initial release with basic OpenTelemetry instrumentation for a Java application running on Apache Tomcat.
### Known Issues
- The demo application may not handle all edge cases and is intended for demonstration purposes only.
### Future Improvements
- Add more complex instrumentation examples.
- Implement additional exporters for different backends (e.g., Jaeger, Prometheus).
### FAQ
- **Q: How do I view the traces and metrics?**
  - A: You can view the logs in the OpenTelemetry Collector by checking the logs of the `otel-collector` service. You can also configure additional exporters to send data to a backend like Jaeger or Prometheus for visualization.
- **Q: Can I run this project on a different port?**
  - A: Yes, you can change the port in the `docker-compose.yml` file under the `ports` section for the `demo-otel-tomcat` service. Make sure to also update the URL you use to access the application.
- **Q: How do I add more instrumentation to the application?**
  - A: You can add more instrumentation by using the OpenTelemetry Java SDK. This involves adding dependencies to your `pom.xml` file and using the SDK to create spans and metrics in your application code.
  - **Q: What if I want to use a different version of OpenTelemetry?**
  - A: You can specify a different version of the OpenTelemetry dependencies in your `pom.xml` file. Make sure to check the compatibility of the version with the OpenTelemetry Collector you are using.
- **Q: How do I customize the OpenTelemetry Collector configuration?**
- A: You can customize the OpenTelemetry Collector configuration by modifying the `otel-collector.yml` file. You can add or remove receivers, exporters, and processors as needed. Make sure to restart the collector service after making changes.
- **Q: Can I run this project without Docker?**
  - A: Yes, you can run the Java application and OpenTelemetry Collector separately without Docker. You would need to set up the OpenTelemetry SDK in your Java application and run the OpenTelemetry Collector as a standalone service.
  - **Q: How do I monitor the performance of the application?**
  - A: You can monitor the performance of the application by using the metrics collected by OpenTelemetry. You can configure exporters to send these metrics to a monitoring backend like Prometheus or Grafana for visualization and analysis.
- **Q: Is there a way to visualize the traces?**
- A: Yes, you can visualize the traces by configuring an exporter to send the trace data to a backend like Jaeger or Zipkin. You would need to add the appropriate dependencies in your `pom.xml` and update the `otel-collector.yml` file to include the exporter configuration.
- **Q: How do I add custom attributes to the spans?**
  - A: You can add custom attributes to spans by using the OpenTelemetry API in your application code. For example, you can use `span.setAttribute("key", "value")` to add an attribute to a span.
  - **Q: Can I use this project as a starting point for my own applications?**
  - A: Yes, you can use this project as a starting point for your own applications. Feel free to modify the code and configuration to suit your needs. Make sure to follow the OpenTelemetry best practices for instrumentation.
  - **Q: How do I contribute to this project?**
  - A: You can contribute to this project by opening issues for bugs or feature requests, submitting pull requests with improvements, or providing feedback on the documentation. Please follow the contribution guidelines in the repository.
  - **Q: Are there any performance considerations when using OpenTelemetry?**
  - A: Yes, there are performance considerations when using OpenTelemetry. It's important to balance the amount of telemetry data collected with the performance impact on your application. You can configure sampling rates and batch processing to optimize performance.
  - **Q: How do I handle sensitive data in traces and metrics?**
  - A: You should avoid including sensitive data in traces and metrics. Use the OpenTelemetry API to filter out or mask sensitive information before sending it to the collector. You can also configure the collector to drop or redact sensitive attributes.
- **Q: Can I use this project with other programming languages?**
- A: This project is specifically designed for Java applications. However, OpenTelemetry supports multiple programming languages, and you can find similar examples for other languages in the OpenTelemetry documentation.
### Conclusion
This project provides a basic setup for instrumenting a Java application running on Apache Tomcat with OpenTelemetry. It serves as a starting point for understanding how to collect traces and metrics in a real-world application. Feel free to extend and modify the project to suit your needs, and explore the OpenTelemetry ecosystem for more advanced features and integrations.
### Feedback
If you have any feedback or suggestions for this project, please feel free to reach out. Your input is valuable and helps improve the project for everyone.
### License
This project is licensed under the MIT License. You can find the full license text in the [LICENSE](LICENSE) file in the project root directory.
### Acknowledgments
This project was made possible by the contributions of the OpenTelemetry community and the developers who have worked on the OpenTelemetry Java SDK and Collector. Special thanks to all contributors for their efforts in making observability accessible to everyone.
### Contact Information
For any questions, feedback, or contributions, please contact the project maintainer at [kojo ampia-addison](mailto:kojo.ampia@jojoaddison.net).