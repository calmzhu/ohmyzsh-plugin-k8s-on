# ohmyzsh-plugin

![main build](https://github.com/calmzhu/ohmyzsh-plugin-k8s-on/actions/workflows/build.yml/badge.svg?branch=main)

## Description

shortcut functions to switch between differnt kubeconfig and namespace

k8s_on cluster_name is a shortcut of "export KUBECONFIG=PATH_TO_YOUR_CLUSTER_KUBE_CONFIG"
kcn kube-namespace is a short cut of "kubectl config set-context --current --namespace=kube-namespace"

## Install
1. Ensure [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) already installed.
1. Install plugin to ohmyzsh customer plugin dir.
    ```zsh
    curl -s https://raw.githubusercontent.com/calmzhu/ohmyzsh-plugin-bookmark/refs/heads/main/install.zsh >install.zsh
    zsh install.zsh $ZSH_CUSTOM
    ```
1. Add **k8s-on** to the plugins array in your zshrc file.
    `plugins=(... k8s-on)`.
```

