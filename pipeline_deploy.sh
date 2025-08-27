#!/bin/bash

# Este script automatiza o processo de CI/CD para a aplicação Quarkus.
# Ele compila a aplicação, constrói a imagem Docker,
# provisiona um cluster Kind e implanta a aplicação.

set -e # Sai do script imediatamente se um comando falhar.

# --- Variáveis de Configuração ---
# Define o nome da aplicação e a tag da imagem
APP_NAME="quarkus-app"
IMAGE_TAG="1.0.0" # Em produção, usaria um hash do commit para imutabilidade.

# --- Passo 1: Limpar e Compilar a Aplicação ---
echo "--- Passo 1: Limpando e Compilando a Aplicação ---"
# O comando clean remove os artefatos de builds anteriores.
# O package compila o código e gera o JAR executável.
mvn clean package -DskipTests

# --- Passo 2: Construir a Imagem Docker ---
echo "--- Passo 2: Construindo a Imagem Docker ---"
# O comando docker build usa o Dockerfile na pasta atual (.)
# e tagueia a imagem com o nome e a versão definidos.
docker build -t $APP_NAME:$IMAGE_TAG .

# --- Passo 3: Provisionar o Cluster Kubernetes (Kind) ---
echo "--- Passo 3: Provisionando o Cluster Kind ---"
# Verifica se o cluster Kind já existe. Se não, ele cria um novo.
if ! kind get clusters | grep -q 'kind-devops'; then
  echo "Criando cluster Kind..."
  kind create cluster --name kind-devops
fi

# Carrega a imagem local para o cluster Kind.
# Isso torna a imagem disponível para os Pods do Kubernetes.
echo "Carregando a imagem Docker para o cluster Kind..."
kind load docker-image $APP_NAME:$IMAGE_TAG --name kind-devops

# --- Passo 4: Implantar no Ambiente de DESENVOLVIMENTO (DES)---

# --- Ambiente de DESENVOLVIMENTO (DES): implantacao ---
echo "--- Passo 4: Implantando no ambiente de DESENVOLVIMENTO ---"
# Aplica os manifestos do Kubernetes para o ambiente DES.
# Os arquivos deployment.yaml e service.yaml já estão no repositório.
kubectl apply -f k8s/

# --- Ambiente de DESENVOLVIMENTO (DES): expondo o servico ---
# Obtém a porta do nó onde o serviço foi exposto.
PORT=$(kubectl get service quarkus-service -o jsonpath='{.spec.ports[0].nodePort}')
IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
echo "A aplicação de DESENVOLVIMENTO está acessível em: http://$IP:$PORT"
echo "Para verificar o status, use: kubectl get pods"

# --- Passo 5: Implantação no Ambiente de PRODUÇÃO ---
# Esta parte será adicionada após a criação dos manifestos de PRD.
# Por enquanto, é um placeholder.
echo "--- Passo 5: Implantando no ambiente de PRODUÇÃO ---"
echo "Esta etapa ainda não está implementada. Faltam os manifestos de PRD."