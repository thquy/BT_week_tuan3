# Stage 1: Build với Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run bằng Tomcat
FROM tomcat:9.0-jdk17

# Xóa app mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy war đã build
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Render sẽ cung cấp biến PORT
ENV PORT=8080

# Config Tomcat dùng PORT của Render
RUN sed -i "s/8080/${PORT}/g" /usr/local/tomcat/conf/server.xml

EXPOSE ${PORT}
CMD ["catalina.sh", "run"]
