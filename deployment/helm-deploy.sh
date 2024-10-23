#!/bin/bash

# Allowed installations
allowed=("helm" "keda" "wc_server_new" "wc_server_update" "ingress")
helm_dir="./deployment/helm/charts/wc-server"

# Function to check if an element is in the allowed array
is_allowed() {
    local element="$1"
    for item in "${allowed[@]}"; do
        if [ "$item" == "$element" ]; then
            return 0
        fi
    done
    return 1
}

# Function to check the entire array passed as arguments
check_input() {
    local array=("$@")
    for input in "${array[@]}"; do
        if ! is_allowed "$input"; then
            echo "Error: '$input' is not a valid helm deployment."
            exit 1
        fi
    done
    echo "All helm deployments are valid."
}

install_helm() {
    echo "Installing helm"
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

install_keda() {
    echo "Installing keda"
    helm repo add kedacore https://kedacore.github.io/charts
    helm repo update
    helm install keda kedacore/keda http-add-on kedacore/keda-add-ons-http --namespace keda --create-namespace --set metricsServer.enabled=true
    helm list -n keda
    kubectl get pods -n keda

    echo "Installing keda-metrics-server"
    kubectl apply -f https://github.com/kedacore/keda-metrics-apiserver/releases/download/v2.14.0/keda-metrics-apiserver.yaml
    kubectl get pods --all-namespaces

    echo "Installing k8s Metrics Server"
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
}


install_ingress() {
    echo "Installing ingress"
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    helm install ingress-nginx ingress-nginx/ingress-nginx --set controller.service.type=NodePort --set controller.service.nodePorts.http=32028
}

install_wc_server_new() {
    echo "Installing ${HELM_RELEASE_NAME}"
    helm install ${HELM_RELEASE_NAME} ${helm_dir}
    helm list
}

install_wc_server_update() {
    echo "Updating ${HELM_RELEASE_NAME}"
    helm upgrade ${HELM_RELEASE_NAME} ${helm_dir}
    helm list
}

# Call the function with all the arguments passed to the script
check_input "$@"
ITEMS_TO_INSTALL=("$@")
for item in "${ITEMS_TO_INSTALL[@]}"; do
    install_function="install_${item}"
    $install_function
done





