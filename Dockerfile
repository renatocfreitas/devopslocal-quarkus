# ---- ETAPA 1: Construção (BUILD) ----
FROM eclipse-temurin:17-jdk-focal AS build

WORKDIR /build

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN chmod +x mvnw

RUN ./mvnw package -Dquarkus.package.type=uber-jar -DskipTests

# ---- ETAPA 2: Execução (RUN) ----
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copia o JAR gerado na etapa de build com o sufixo "-runner"
# para a imagem final e o renomeia para "quarkus-app.jar".
COPY --from=build /build/target/getting-started-1.0.0-SNAPSHOT-runner.jar ./quarkus-app.jar

# Expõe a porta padrão do Quarkus
EXPOSE 8080

# Comando para rodar a aplicação quando o container for iniciado
CMD ["java", "-jar", "quarkus-app.jar"]