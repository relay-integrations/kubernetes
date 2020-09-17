# kubernetes-step-kubectl

This Kubectl step container allows general `kubectl` use and can take `kubectl` commands.

## Examples

Here is an example of the step in a Relay workflow:

```YAML
steps:

...

- name: kubectl
  image: relaysh/kubernetes-step-kubectl
  spec:
    command: apply
    args: 
    - "-k"
    - "dir/"
    file: infra/resources.yaml
    namespace: default
    cluster:
      name: my-cluster
      connection: !Connection { type: kubernetes, name: my-cluster }
    git: 
      ssh_key:
        $type: Secret
        name: ssh_key
      known_hosts:
        $type: Secret
        name: known_hosts
      name: my-git-repo
      branch: dev
      repository: path/to/your/repo
```
