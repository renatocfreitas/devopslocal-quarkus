# devopslocal-quarkus
O objetivo é automatizar a implantação de uma aplicação Quarkus em um ambiente Kubernetes local, utilizando ferramentas de automação, simulando uma pipeline completa de entrega contínua. Esse desafio foca em práticas de DevOps, como entrega contínua, versionamento, e infraestrutura como código.
1. Título e Descrição do Projeto
Título: Desafio Técnico: Implantação Automatizada em Ambiente Orquestrado

Descrição: Uma breve introdução do que o projeto faz, mencionando o objetivo de automatizar o CI/CD de uma aplicação Quarkus em um cluster Kubernetes local, usando ferramentas como Kind, Docker e shell scripting.

2. Arquitetura da Solução
Diagrama: Se possível, inclua um diagrama simples mostrando o fluxo da pipeline.

Git: Onde o código-fonte reside.

Pipeline (Script Bash): O orquestrador da pipeline.

Build/Docker: Onde a imagem é criada.

Kind (Kubernetes): Onde a imagem é implantada.

Componentes: Liste as ferramentas e tecnologias utilizadas e por que foram escolhidas:

Aplicação: Quarkus Quickstart (getting-started)

Cluster K8s: Kind (Kubernetes in Docker)

Containerização: Docker

Automação: Shell Scripting (Bash)

Versionamento: Git

3. Pré-requisitos e Instalação
Esta seção é crucial para a reprodutibilidade do seu projeto.

Ambiente: Indique o ambiente de desenvolvimento usado (Ex: Windows 11 com WSL2/Ubuntu).

Ferramentas Necessárias:

Git: Link para a instalação.

Docker Desktop: Mencione que ele já inclui o Docker CLI e a integração com o WSL2.

Kind: Inclua o comando de instalação direta, como discutimos.

kubectl: Inclua o comando para instalar via apt no WSL2.

Maven: Inclua o comando de instalação via apt.

Configuração: Explique como garantir que o PATH está configurado corretamente para o kind.exe e como o kubectl no WSL2 se conecta ao cluster.

4. Passo a Passo da Implantação (A Pipeline)
Esta é a seção que explica a automação. Descreva cada etapa do seu script de pipeline.

Passo 1: Clonar o Repositório: git clone <URL_DO_REPOSITÓRIO>

Passo 2: Iniciar o Cluster Kind: kind create cluster

Passo 3: Construir a Imagem:

Explique o comando mvn package e o Dockerfile.

Mencione a tag da imagem e a estratégia de versionamento.

Passo 4: Implantar no Ambiente DES:

Explique o que é o arquivo deployment-des.yaml.

Mostre o comando kubectl apply -f k8s/des/.

Passo 5: Implantar no Ambiente PRD:

Explique a diferença do deployment-prd.yaml (ex: mais réplicas, diferentes variáveis de ambiente).

Mostre o comando kubectl apply -f k8s/prd/.

5. Estratégia de Versionamento
Versionamento do Código: Explique que o versionamento segue o fluxo de trabalho do Git (commits, branches, tags).

Versionamento das Imagens: Descreva como as imagens do Docker são tagueadas, por exemplo, usando a versão do aplicativo (v1.0.0) ou um hash do commit (v1.0.0-git-hash).

6. Validação e Testes
Como validar a implantação:

Comandos kubectl para checar o estado dos pods e serviços: kubectl get pods, kubectl get service.

Como obter a URL de acesso à aplicação (ex: kubectl port-forward ... ou minikube service ...).

Testes de Conectividade: Inclua comandos curl para verificar se a aplicação está respondendo.

7. Apêndices e Códigos
Scripts de Automação: Crie uma subseção para cada script (no seu caso, o pipeline-deploy.sh). Cole o código e inclua comentários curtos para cada comando.

Arquivos YAML: Inclua o conteúdo dos arquivos deployment-des.yaml e deployment-prd.yaml.

Dockerfile: Inclua o Dockerfile final que você construiu.