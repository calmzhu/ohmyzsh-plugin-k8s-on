k8s_on() {
    if [ -z "$1" ]; then
        echo "Current KUBECONFIG: ${KUBECONFIG:-~/.kube/config}"
        echo "Available kubeconfig files in ~/.kube/:"
        find ~/.kube -name "config*" -type f -exec basename {} \; 2>/dev/null
        return 0
    fi

    local config_file="$1"
    local full_path

    if [[ "$config_file" != /* ]]; then
        full_path="$HOME/.kube/$config_file"
    else
        full_path="$config_file"
    fi

    if [ ! -f "$full_path" ]; then
        echo "Error: Kubeconfig file not found: $full_path" >&2
        return 1
    fi

    export KUBECONFIG="$full_path"
    echo "Switched to kubeconfig: $config_file"

    echo "Current context: $(kubectl config current-context 2>/dev/null || echo 'None')"
}

compdef _k8s_on_completion k8s_on
_k8s_on_completion() {
    local -a config_files
    config_files=("${(@f)$(find ~/.kube -maxdepth 1 -type f -exec basename {} \; 2>/dev/null)}")
    _describe 'kubeconfig files' config_files
}
