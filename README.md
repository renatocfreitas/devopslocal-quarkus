O objetivo deste projeto é automatizar a implantação de uma aplicação Quarkus em um ambiente Kubernetes local, utilizando ferramentas de automação, simulando uma pipeline completa de entrega contínua. Esse desafio foca em práticas de DevOps, como entrega contínua, versionamento, e infraestrutura como código.

1. Título e Descrição do Projeto
Título: Desafio Técnico: Implantação Automatizada em Ambiente Orquestrado

Descrição: Este projeto visa automatizar o CI/CD (Continuous Integration/Continuous Delivery) de uma aplicação Quarkus em um cluster Kubernetes local, utilizando ferramentas como Kind, Docker e Shell scripting. A pipeline simula as etapas de build, containerização e implantação, garantindo um processo de entrega contínua eficiente e reprodutível.

2. Arquitetura da Solução
Diagrama de Fluxo da Pipeline:

Fluxo do pipeline esquematizado:

A[Código-Fonte] --> B(Pipeline - Shell Script);
B --> C[Construção da Imagem Docker];
C --> D[Criação e Implantação no Cluster Kind];
D --> E[Aplicação em Pods e Services];
E --> F(Acesso à Aplicação);

Componentes:
Aplicação: Quarkus Quickstart (getting-started).

Cluster K8s: Kind (Kubernetes in Docker), para simular um ambiente Kubernetes local.

Containerização: Docker.

Automação: Shell Scripting (Bash).

Versionamento: Git.

3. Pré-requisitos e Instalação
O ambiente de execução utilizado foi o Windows 11 Pro com WSL2/Ubuntu.

Ferramentas Necessárias:

Git: Para o versionamento do código.

Instalação: https://git-scm.com/downloads

Docker Desktop: Inclui o Docker CLI e a integração com o WSL2.

Instalação: https://docs.docker.com/desktop/install/windows-install/

Configuração: Em Settings > Resources > WSL Integration, certifique-se de que a distribuição Ubuntu está ativada.

Kind: Para a criação do cluster Kubernetes local.

Instalação (no WSL2/Ubuntu):

Bash
```
[ -d /usr/local/bin ] || sudo mkdir -p /usr/local/bin
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```
kubectl: A ferramenta de linha de comando para interagir com clusters Kubernetes.

Instalação (no WSL2/Ubuntu):

Bash
``` 
sudo apt-get update
sudo apt-get install -y kubectl
```
Maven: A ferramenta de build para o projeto Java (Quarkus).

Instalação (no WSL2/Ubuntu):

Bash
```
sudo apt-get install -y maven
```
Configuração:

O Kind instalado diretamente no WSL2 já adiciona o executável ao seu PATH, garantindo que o seu script bash o encontre.

O kubectl instalado no WSL2 se conectará automaticamente ao cluster Kind criado pelo Docker Desktop, pois o Docker Desktop gerencia o kubeconfig.

4. Passo a Passo da Implantação (A Pipeline)

O script ./pipeline_deploy.sh orquestra todas as etapas de implantação.

Passo 1: Construção da Imagem Docker
O script usa o Dockerfile para compilar o projeto Quarkus e criar uma imagem Docker. O comando docker build lê o Dockerfile, compila a aplicação com o Maven e gera a imagem.

Passo 2: Provisionamento do Cluster Kind
O pipeline_deploy.sh cria um cluster Kubernetes local, caso ele ainda não exista.

Passo 3: Implantação no Ambiente DES
O script usa kubectl apply -f k8s/des/ para implantar a aplicação. Este comando lê o arquivo deployment-des.yaml, criando um Deployment e um Service que expõem a aplicação.

Passo 4: Implantação no Ambiente PRD
(Se aplicável) Se houver um ambiente de produção simulado, o script usa kubectl apply -f k8s/prd/ para implantar a aplicação. O deployment-prd.yaml pode conter diferenças como um número maior de réplicas e variáveis de ambiente específicas para produção.

5. Estratégia de Versionamento

Versionamento do Código: Utiliza o Git para gerenciar o código-fonte. Cada alteração é rastreada com commits, e diferentes funcionalidades são desenvolvidas em branches dedicadas.

Versionamento das Imagens: As imagens Docker são tagueadas para garantir a rastreabilidade. A tag pode ser a versão do aplicativo (v1.0.0), um hash do commit do Git (v1.0.0-git-abcde), ou a data e hora da compilação.

6. Validação e Testes

Para garantir que a implantação foi bem-sucedida, utilize os seguintes comandos:

Verificação de Pods e Deployments:

Bash
```
kubectl get pods
kubectl get deployments
``` 
Obtenção da URL de Acesso:

Bash
```
kubectl get service quarkus-service
```
A URL de acesso será 
```
http://localhost:<porta-NodePort>
```
, onde porta-NodePort é o valor listado na saída do comando acima (ex.: 8080).

Testes de Conectividade:
Use curl para verificar se a aplicação está respondendo corretamente.

Verifique o pod.
```
$ kubectl get pods
NAME                           READY   STATUS    RESTARTS   AGE
quarkus-app-67cbc9d64c-6zdxp   1/1     Running   0          28m
```
Defina a porta 8080 para associar a porta do pod à porta da máquina.
```
$ kubectl port-forward quarkus-app-67cbc9d64c-6zdxp 8080:8080
```
Em seguida, teste a aplicação.
Bash
```
curl http://localhost:<porta-NodePort>/hello
```

7. Apêndices e Códigos resumidos

pipeline_deploy.sh
Bash
```
#!/bin/bash

# --- Passo 1: Construindo a Imagem Docker ---
echo "--- Passo 1: Construindo a Imagem Docker ---"
docker build -t quarkus-app:1.0.0 .

# --- Passo 2: Provisionando o Cluster Kind ---
echo "--- Passo 2: Provisionando o Cluster Kind ---"
kind create cluster --wait 30s || true

# --- Passo 3: Implantando no ambiente de DES ---
echo "--- Passo 3: Implantando no ambiente de DES ---"
kubectl apply -f k8s/des/

# --- Passo 4: Verificando o status da implantação ---
echo "--- Passo 4: Verificando o status da implantação ---"
kubectl get pods
kubectl get services

# --- Passo 5: Acessando a aplicação ---
echo "--- Passo 5: Acessando a aplicação ---"
PORT=$(kubectl get service quarkus-service -o jsonpath='{.spec.ports[0].nodePort}')
echo "A aplicação de DES está acessível em: http://localhost:${PORT}"
```

Dockerfile

```
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

COPY --from=build /build/target/getting-started-1.0.0-SNAPSHOT-runner.jar ./quarkus-app.jar

EXPOSE 8080

CMD ["java", "-jar", "quarkus-app.jar"]
k8s/des/deployment-des.yaml (Exemplo)
YAML

apiVersion: apps/v1
kind: Deployment
metadata:
  name: quarkus-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: quarkus-app
  template:
    metadata:
      labels:
        app: quarkus-app
    spec:
      containers:
      - name: quarkus-app
        image: quarkus-app:1.0.0
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: quarkus-service
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 8080
  selector:
    app: quarkus-app
```