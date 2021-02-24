# eosio.helm
Helm charts for EOSIO.

## How to install nodeos via Helm.

### How to install via Docker Desktop.

1. Install Docker Desktop.
    * [Docker Official: Desktop](https://docs.docker.com/desktop)
1. Install Kubernetes command-line tool (kubectl).
    * [Kubernetes Official: Install and Set Up Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl)
1. Install Helm.
    * [Helm Official: Installing Helm](https://helm.sh/docs/intro/install)
1. Configure Helm and Kubernetes for deployment.
    1. Helm repo add `eosio.helm` public repository.
    1. Set Kubernetes to use the Docker Desktop context.
1. Deploy Nodeos.
    1. Perform `helm dependency update` for chain.
        * [Code: eosio/scripts/helm-dependency-update.sh](eosio/scripts/helm-dependency-update.sh)
    1. Perform `helm upgrade --install eosio eosio -f eosio/local.yaml -f eosio/nodeos_config.yaml`
        * [Code: eosio/local.yaml](eosio/local.yaml)
        * [Code: eosio/nodeos_config.yaml](eosio/nodeos_config.yaml)

### How to install using a cloud provider like AWS or GCP.

1. Perform `helm dependency update` for chain.
    * [Code: eosio/scripts/helm-dependency-update.sh](eosio/scripts/helm-dependency-update.sh)
1. Perform `helm upgrade --install eosio eosio -f eosio/primary.yaml -f eosio/nodeos_config.yaml`
    * [Code: eosio/primary.yaml](eosio/primary.yaml)
    * [Code: eosio/nodeos_config.yaml](eosio/nodeos_config.yaml)

## How to customize your configuration values.

1. Specify additional value files as desired using additional `-f` options. Remember that order matters and values are overridden from left-to-right in specification.
    * [Helm Official: Value Files](https://helm.sh/docs/chart_template_guide/values_files)
1. Specify values directly as commandline arguments.
    * [Helm Official: Using Helm](https://helm.sh/docs/intro/using_helm)

## How to configure specific artifacts.

### How to configure cloud provider.

* Cloud provider: `.Values.global.cloudProvider`
* Autoscaler: `.Values.global.nodeSelector`
