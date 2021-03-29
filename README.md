# eosio.helm
[EOSIO](https://github.com/EOSIO/eos) enables businesses to rapidly build and deploy high-performance and high-security blockchain-based applications.

Official support for Helm charts goes one step further! Now deploy EOSIO application(s) via Kubernetes with premade templates.

## How to install and run locally via Docker Desktop.

1. Install Docker Desktop.
    * [Docker Official: Desktop](https://docs.docker.com/desktop)
1. Install Kubernetes command-line tool (kubectl).
    * [Kubernetes Official: Install and Set Up Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl)
1. Install Helm.
    * [Helm Official: Installing Helm](https://helm.sh/docs/intro/install)
1. Configure Helm and Kubernetes for deployment.
    1. Helm repo add `eosio.helm` public repository.
    1. Set Kubernetes to use the Docker Desktop context.
        1. Verify the current context using `kubectl config current-context`.
        1. If the current context is not Docker Desktop, then
            1. Get a list of contexts via `kubectl config get-contexts`.
            1. Set the current context to the Docker Desktop Kubernetes namespace via `kubectl config use-context <docker local>`.
1. Deploy a Helm Chart for EOSIO applications.
    1. Configure Helm Chart subpackages via `helm dependency update`.
        * [Code: eosio/scripts/helm-dependency-update.sh](eosio/scripts/helm-dependency-update.sh)
    1. Deploy EOSIO via `helm upgrade --install eosio eosio -f eosio/local.yaml -f eosio/nodeos_config.yaml`
        * [Code: eosio/local.yaml](eosio/local.yaml)
        * [Code: eosio/nodeos_config.yaml](eosio/nodeos_config.yaml)

## How to install using a cloud provider like AWS or GCP.

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

## Contributing

[Contributing Guide](./CONTRIBUTING.md)

[Code of Conduct](./CONTRIBUTING.md#conduct)

## License

[MIT](./LICENSE)

## Important

See [LICENSE](./LICENSE) for copyright and license terms.

All repositories and other materials are provided subject to the terms of this [IMPORTANT](./IMPORTANT.md) notice and you must familiarize yourself with its terms.  The notice contains important information, limitations and restrictions relating to our software, publications, trademarks, third-party resources, and forward-looking statements.  By accessing any of our repositories and other materials, you accept and agree to the terms of the notice.
