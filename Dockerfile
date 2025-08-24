# ---- ETAPA 1: Construção (BUILD) ----
# Usa uma imagem com o JDK 17, ideal para compilar a aplicação Quarkus.
FROM eclipse-temurin:17-jdk-focal AS build

# Define o diretório de trabalho dentro do container
WORKDIR /build

# Copia os arquivos do Maven e o código-fonte para a imagem
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

# Garante que o script do Maven seja executável
RUN chmod +x mvnw

# Compila a aplicação e gera o JAR executável.
# O "uber-jar" agrupa tudo em um único arquivo, simplificando a etapa final.
RUN ./mvnw package -Dquarkus.package.type=uber-jar -DskipTests

# ---- ETAPA 2: Execução (RUN) ----
# Usa uma imagem com o JRE 17, mais leve que o JDK.
FROM eclipse-temurin:17-jre-alpine

# Define o diretório de trabalho
WORKDIR /app

# Copia o JAR gerado na etapa de build (quarkus-quickstarts-1.0.0-SNAPSHOT-runner.jar)
# para a imagem final e o renomeia para "quarkus-app.jar".
COPY --from=build /build/target/quarkus-quickstarts-1.0.0-SNAPSHOT-runner.jar ./quarkus-app.jar

# Expõe a porta padrão do Quarkus
EXPOSE 8080

# Comando para rodar a aplicação quando o container for iniciado
CMD ["java", "-jar", "quarkus-app.jar"]