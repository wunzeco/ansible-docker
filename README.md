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
    - wunzeco.docker
```


- To configure server as docker swarm manager:

```
  vars:
    docker_swarm_manager: true
    docker_opts: []

  roles:
    - wunzeco.docker
```


## Testing

To run this role's integration tests

```
PLATFORM=ubuntu-1404      # OR centos OR ubuntu-1604
kitchen verify $PLATFORM && kitchen destroy $PLATFORM 
```


## Dependencies

none
