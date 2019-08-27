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
    - o2-priority.docker
```


- To configure server as docker swarm manager:

```
  vars:
    docker_swarm_manager: true
    docker_opts: []

  roles:
    - o2-priority.docker
```

## Testing
To run integration tests of this role

PLATFORM = ubuntu or centos
```
kitchen test $PLATFORM --destroy=never && docker kill smanager snode && docker rm smanager snode
```

> **Note:**
> `--destroy=never` must be supplied because multiple nodes are required to be running for all the tests to pass. As a consequence of this `$PLATFORM` must also be specified for the `kitchen test` command otherwise it will not work because of the `instance_name` property. The `docker` commands remove the left over containers for the next platform run


## Dependencies

none
