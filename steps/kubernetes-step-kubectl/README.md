# kubernetes-step-kubectl

This Kubectl step container allows general `kubectl` use and can take `kubectl` commands.

## Specifications

| Setting     | Child setting | Data type        | Description                                                                                                                                    | Default   | Required                |
|-------------|---------------|------------------|------------------------------------------------------------------------------------------------------------------------------------------------|-----------|-------------------------|
| `cluster`   |               | mapping          | A map of configuration and credentials for accessing a Kubernetes cluster.                                                                     | None      | True                    |
|             | `name`        | string           | A name for the Kubernetes cluster. Used for referencing it via `kubectl` contexts.                                                             | None      | True                    |
|             | `connection`  | Relay Connection | The Relay Kubernetes cluster connection.                                                                                                       | None      | True                    |
| `command`   |               | string           | The command to pass to `kubectl`. For example, "apply".                                                                                        | None      | True                    |
| `args`      |               | string           | A string of arguments for commands other than "apply".                                                                                         | None      | False                   |
| `file`      |               | string           | A resource file to use when command is "apply".                                                                                                | None      | When command is "apply" |
| `namespace` |               | string           | The namespace to run the command under.                                                                                                        | `default` | False                   |
| `git`       |               | mapping          | A map of git configuration. If you're using HTTPS, only `name` and `repository` are required.                                                  | None      | False                   |
|             | `ssh_key`     | string           | The SSH key to use when cloning the git repository. You can pass the key to Relay as a secret. See the example below.                          | None      | True                    |
|             | `known_hosts` | string           | SSH known hosts file. Use a Relay secret to pass the contents of the file into the workflow as a base64-encoded string. See the example below. | None      | True                    |
|             | `name`        | string           | A directory name for the git clone.                                                                                                            | None      | True                    |
|             | `branch`      | string           | The Git branch to clone.                                                                                                                       | `master`  | False                   |
|             | `repository`  | string           | The git repository URL.                                                                                                                        | None      | True                    |

> **Note**: The value you set for a secret must be a string. If you have multiple key-value pairs to pass into the secret, or your secret is the contents of a file, you must encode the values using base64 encoding, and use the encoded string as the secret value.

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
