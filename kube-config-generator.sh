#! /bin/bash

function valid_required_envs() {
	# Configs
	required_envs=(KUBE_CONTEXT KUBE_SERVER)
	# Securities
	required_envs+=(KUBE_CERTIFICATE_AUTHORITY)
	required_envs+=(KUBE_CLIENT_CERTIFICATE KUBE_CLIENT_KEY)

	errors=()

	for key in "${required_envs[@]}"; do
		if [[ -z "${!key}" ]]; then
			errors+=("The variable \$${key} can't be empty.")
		fi
	done

	if [[ ! -z "${errors[@]}" ]]; then
		echo "Errors:"
		printf "  %s\n" "${errors[@]}"
		exit 1
	fi
}

valid_required_envs

KUBE_CLUSTER=${KUBE_CLUSTER:-$KUBE_CONTEXT}
KUBE_USER=${KUBE_USER:-$KUBE_CONTEXT}

KUBECONFIG=${KUBECONFIG:-$HOME/.kube/config}
KUBE_CONFIG_DIR=$(dirname "${KUBECONFIG}")

mkdir -p "${KUBE_CONFIG_DIR}"

kubectl config set-cluster ${KUBE_CLUSTER} \
	--server=${KUBE_SERVER}

kubectl config set-context ${KUBE_CONTEXT} \
	--cluster=${KUBE_CLUSTER} \
	--user=${KUBE_USER}

kubectl config set clusters.${KUBE_CONTEXT}.certificate-authority-data ${KUBE_CERTIFICATE_AUTHORITY}
kubectl config set users.${KUBE_CONTEXT}.client-certificate-data ${KUBE_CLIENT_CERTIFICATE}
kubectl config set users.${KUBE_CONTEXT}.client-key-data ${KUBE_CLIENT_KEY}

kubectl config use-context ${KUBE_CONTEXT}

echo "Success generating context ${KUBE_CONTEXT} in \`${KUBECONFIG}\`"
