# devopslocal-quarkus
O objetivo é automatizar a implantação de uma aplicação Quarkus em um ambiente Kubernetes local, utilizando ferramentas de automação, simulando uma pipeline completa de entrega contínua. Esse desafio foca em práticas de DevOps, como entrega contínua, versionamento, e infraestrutura como código.

1. Título e Descrição do Projeto
Título: Desafio Técnico: Implantação Automatizada em Ambiente Orquestrado

Descrição: Este projeto objetiva automatizar o CI/CD de uma aplicação Quarkus em um cluster Kubernetes local, utilizando como o Kind, Docker e Shell scripting.

2. Arquitetura da Solução
Diagrama: Se possível, inclua um diagrama simples mostrando o fluxo da pipeline.

Git: Onde o código-fonte reside.

Pipeline (Script Bash): O orquestrador da pipeline.

Build/Docker: Onde a imagem é criada.

Kind (Kubernetes): Onde a imagem é implantada.

Componentes: 

Aplicação: Quarkus Quickstart (getting-started), oferecida pelo desafio.

Cluster K8s: Kind (Kubernetes in Docker), para implementação do ambiente Kubernetes local, simulando pods em containers Docker.

Containerização: Docker

Automação: Shell Scripting (Bash)

Versionamento: Git

3. Pré-requisitos e Instalação
Esta seção é crucial para a reprodutibilidade do seu projeto.

Ambiente: Windows 11 Pro com WSL2/Ubuntu

Ferramentas Necessárias:

Git: Link para a instalação: https://git-scm.com/downloads

Docker Desktop: Inclui o Docker CLI e a integração com o WSL2 (no docker desktop, configure a integração em Settings - Resources - WSL integration). Link para instalação: https://docs.docker.com/desktop/setup/install/windows-install/

Kind: 
Conforme o link https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries, para instalar o Kind no Windows, execute os dois comandos abaixo no PowerShell Administrador:
C:>curl.exe -Lo kind-windows-amd64.exe https://kind.sigs.k8s.io/dl/v0.29.0/kind-windows-amd64
C:>Move-Item .\kind-windows-amd64.exe .\kind.exe

Mova o executável para o caminho desejado Ex.: C:\tools\kind\kind.exe.
Em seguida, configure o PATH do Windows adicionando este caminho.
Para configurar o PATH, no prompt do Power Shell Administrator:
PS> $env:Path += ";C:\tools\kind"

Para persistir o novo caminho no registro do Windows, no prompt do Power Shell Administrator:
PS> [System.Environment]::SetEnvironmentVariable('PATH', $env:Path, 'Machine')

Para verificar o novo caminho no PATH, no prompt do Power Shell:
PS> $env:PATH

kubectl: Para instalar, execute no prompt WSL2: sudo apt-get install -y kubectl

Maven: Para instalar, execute no prompt WSL2: sudo apt-get install -y maven

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