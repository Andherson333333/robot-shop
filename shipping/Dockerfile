# Etapa de construcción
FROM maven:3.6-jdk-8 AS build
WORKDIR /opt/shipping
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# Etapa de ejecución
FROM openjdk:8-jre-slim
ENV INSTANA_AUTO_PROFILE=true
ENV INSTANA_SERVICE_NAME=shipping
ENV CART_ENDPOINT=cart:8080
ENV DB_HOST=mysql
EXPOSE 8080
WORKDIR /opt/shipping
COPY --from=build /opt/shipping/target/shipping-1.0.jar shipping.jar
CMD ["java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar"]
