# ==================================================
# k8s_on - 切换并设置 KUBECONFIG 环境变量
# 用法: k8s_on [kubeconfig文件名]
# ==================================================
k8s_on() {
    if [ -z "$1" ]; then
        # 如果没有参数，显示当前设置
        echo "Current KUBECONFIG: ${KUBECONFIG:-~/.kube/config}"
        echo "Available kubeconfig files in ~/.kube/:"
        find ~/.kube -name "config*" -type f -exec basename {} \; 2>/dev/null
        return 0
    fi

    local config_file="$1"
    local full_path
    
    # 如果输入的不是绝对路径，则在 ~/.kube/ 目录下查找
    if [[ "$config_file" != /* ]]; then
        full_path="$HOME/.kube/$config_file"
    else
        full_path="$config_file"
    fi

    if [ ! -f "$full_path" ]; then
        echo "Error: Kubeconfig file not found: $full_path" >&2
        return 1
    fi

    # 设置 KUBECONFIG 环境变量
    export KUBECONFIG="$full_path"
    echo "Switched to kubeconfig: $config_file"
    
    # 显示当前上下文
    echo "Current context: $(kubectl config current-context 2>/dev/null || echo 'None')"
}

# ==================================================
# kcn - 快速切换 Kubernetes namespace
# 用法: kcn [namespace名称]
# ==================================================
kcn() {
    if [ -z "$1" ]; then
        # 如果没有参数，显示当前namespace和可用列表
        local current_ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
        echo "Current namespace: ${current_ns:-default}"
        echo "Available namespaces in current context:"
        kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n' | sort
        return 0
    fi

    # 切换到指定namespace
    if kubectl config set-context --current --namespace="$1" >/dev/null 2>&1; then
        echo "Switched to namespace: $1"
    else
        echo "Error: Failed to switch to namespace: $1" >&2
        return 1
    fi
}

# k8s_on 自动补全 - 补全 ~/.kube/ 下的 config 文件
compdef _k8s_on_completion k8s_on
_k8s_on_completion() {
    local -a config_files
    # 查找 ~/.kube 下所有以 config 开头的文件，只显示文件名
    config_files=("${(@f)$(find ~/.kube -name "config*" -type f -exec basename {} \; 2>/dev/null)}")
    _describe 'kubeconfig files' config_files
}

# kcn 自动补全 - 补全当前集群中的 namespace
compdef _kcn_completion kcn
_kcn_completion() {
    local -a namespaces
    # 获取当前上下文中可用的 namespace
    namespaces=("${(@f)$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' 2>/dev/null)}")
    _describe 'namespaces' namespaces
}


