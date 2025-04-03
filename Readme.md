# Gerenciamento de Clusters Kubernetes na DigitalOcean com Terraform e Workspaces

## Introdução
Este laboratório demonstra como criar e importar um cluster Kubernetes manualmente na DigitalOcean para gerenciá-lo com Terraform. Além disso, utilizamos o recurso de **Terraform Workspaces** para separar os ambientes de produção e homologação, garantindo uma infraestrutura organizada e escalável.

## Pré-requisitos
Antes de iniciar, certifique-se de ter os seguintes itens configurados:
- Conta na [DigitalOcean](https://www.digitalocean.com/)
- [Terraform instalado](https://developer.hashicorp.com/terraform/downloads)
- Token de acesso da DigitalOcean
- [kubectl instalado](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## 1. Criando um Cluster Kubernetes na DigitalOcean
1. Acesse a [interface da DigitalOcean](https://cloud.digitalocean.com/).
2. No menu lateral, clique em **Kubernetes**.
3. Selecione **Create a Kubernetes Cluster**.
4. Escolha as seguintes configurações:
   - **Name:** `k8s-prod`
   - **Region:** `nyc1`
   - **Kubernetes Version:** `1.32.2-do.0`
   - **Node Pool Name:** `pool-k8s`
   - **Node Size:** `s-2vcpu-2gb`
   - **Node Count:** `2`
5. Clique em **Create Cluster** e aguarde a finalização.

## 2. Importando o Cluster para o Terraform
Após criar o cluster, precisamos importar seu estado para o Terraform.

### 2.1 Criando os arquivos Terraform
No diretório do projeto, crie os seguintes arquivos:

#### **`main.tf`**
```hcl
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.50.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_kubernetes_cluster" "k8s_prod" {
  name = var.k8s_name
}
```

#### **`variaveis.tf`**
```hcl
variable "do_token" {
  type = string
}

variable "k8s_name" {
  type    = string
  default = "k8s-prod"
}
```

### 2.2 Importando o Cluster
Para importar o cluster criado manualmente, obtenha o ID do cluster na interface da DigitalOcean e execute o comando:

```sh
terraform import digitalocean_kubernetes_cluster.k8s_prod 757cf604-c9c4-420b-8638-9a8f9bac63fa
```

Se tudo der certo, o Terraform irá associar o cluster existente ao código Terraform.

## 3. Configurando Workspaces para Ambientes
O Terraform Workspaces permite separar os estados entre diferentes ambientes. Vamos configurar os workspaces **prod** e **homolog**.

### 3.1 Criando Workspaces
Execute os seguintes comandos:
```sh
terraform workspace new prod
terraform workspace new homolog
```

Para alternar entre os workspaces:
```sh
terraform workspace select prod  # Seleciona o workspace de produção
terraform workspace select homolog  # Seleciona o workspace de homologação
```

### 3.2 Criando Arquivos de Variáveis para Ambientes
Crie dois arquivos para os diferentes ambientes:

#### **`k8s_prod.tfvars`**
```hcl
k8s_name = "k8s-prod"
```

#### **`k8s_homolog.tfvars`**
```hcl
k8s_name = "k8s-homolog"
```

### 3.3 Aplicando as Configurações
Para aplicar a configuração no ambiente de produção:
```sh
terraform apply -var-file=k8s_prod.tfvars
```
Para o ambiente de homologação:
```sh
terraform apply -var-file=k8s_homolog.tfvars
```

## Conclusão
Agora temos um cluster Kubernetes gerenciado pelo Terraform com separação de ambientes via Workspaces. Isso garante maior controle, escalabilidade e organização na infraestrutura.

---

### 📌 Possíveis Melhorias
- Adicionar módulos Terraform para reutilização de código.
- Integrar com um CI/CD para automação do deploy dos clusters.
- Implementar variáveis sensíveis usando **Terraform Cloud** ou **Vault**.

---

Este repositório foi criado para facilitar a gestão de clusters Kubernetes na DigitalOcean com Terraform. Contribuições são bem-vindas! 🚀

