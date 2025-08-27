#!/bin/bash

# Este script automatiza o processo de CI/CD para a aplicação Quarkus.
# Ele compila a aplicação, constrói a imagem Docker,
# provisiona um cluster Kind e implanta a aplicação.

# O script aceita um argumento para definir o ambiente de implantação.
# Exemplo de uso: ./pipeline-deploy.sh des
# Exemplo de uso: ./pipeline-deploy.sh prd

set -e # Sai do script imediatamente se um comando falhar.

# --- Variáveis de Configuração ---
# Define o nome da aplicação e a tag da imagem
APP_NAME="quarkus-app"
IMAGE_TAG="1.0.0"

# --- Passo 1: Limpar e Compilar a Aplicação ---
echo "--- Passo 1: Limpando e Compilando a Aplicação ---"
mvn clean package -DskipTests

# --- Passo 2: Construir a Imagem Docker ---
echo "--- Passo 2: Construindo a Imagem Docker ---"
docker build -t $APP_NAME:$IMAGE_TAG .

# --- Passo 3: Provisionar o Cluster Kubernetes (Kind) ---
echo "--- Passo 3: Provisionando o Cluster Kind ---"
if ! kind get clusters | grep -q 'kind-devops'; then
  echo "Criando cluster Kind..."
  kind create cluster --name kind-devops
fi

echo "Carregando a imagem Docker para o cluster Kind..."
kind load docker-image $APP_NAME:$IMAGE_TAG --name kind-devops

# --- Passo 4: Implantar nos Ambientes ---

# Recebe o argumento do ambiente. Se nenhum for fornecido, assume "des"
ENV=${1:-des}

if [ "$ENV" == "des" ]; then
  echo "--- Passo 4: Implantando no ambiente de DESENVOLVIMENTO ---"
  # Aplica os manifestos para o ambiente DES
  kubectl apply -f k8s/deployment.yaml -f k8s/service.yaml
  
  # Expondo o Serviço de Desenvolvimento
  echo "Aguardando o serviço de desenvolvimento..."
  sleep 10
  PORT=$(kubectl get service quarkus-service -o jsonpath='{.spec.ports[0].nodePort}')
  IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
  echo "A aplicação de DES está acessível em: http://$IP:$PORT"

elif [ "$ENV" == "prd" ]; then
  echo "--- Passo 4: Implantando no ambiente de PRODUÇÃO ---"
  # Aplica os manifestos para o ambiente PRD
  kubectl apply -f k8s/deployment-prd.yaml -f k8s/service-prd.yaml

  # Expondo o Serviço de Produção
  echo "Aguardando o serviço de produção..."
  sleep 10
  PORT=$(kubectl get service quarkus-service-prd -o jsonpath='{.spec.ports[0].nodePort}')
  IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
  echo "A aplicação de PRD está acessível em: http://$IP:$PORT"

else
  echo "ERRO: Ambiente inválido. Use 'des' ou 'prd'."
  exit 1
fi