DOCKER
=====

Ansible role to install and configure Docker engine


## Example

- To configure install and configure docker engine with remote api enabled:

```
  vars:
    docker_port: 2375
    docker_opts:
      - "-H tcp://0.0.0.0:{{ docker_port }}"
      - "-H unix:///var/run/docker.sock"

  roles:
    - ogonna.iwunze.docker
```


- To configure server as docker swarm master:

```
  vars:
    docker_swarm_master: true
    docker_opts: []

  roles:
    - ogonna.iwunze.docker
```
