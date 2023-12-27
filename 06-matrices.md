## before using matrix:

```yaml
name: matrix deploy
on: push
jobs:
  run_on_ubuntu:
    runs-on: ubuntu-latest
    steps:
      - name: run image
        run: docker run hello-world
      - name: list container
        run: docker ps -l
  run_on_windows:
    runs-on: windows-latest
    steps:
      - name: run image
        run: docker run hello-world
      - name: inspect container
        run: docker inspect hello-world
```
## after using matrices
```yaml
name: using matrices
on: push
jobs:
  deploy_on:
    strategy:
      matrix:
        version: [latest]
        os: [ubuntu, windows]
        image: [hello-world, alpine]
    runs-on: ${{matrix.os}}-${{matrix.version}}

    steps:
      - name: run image on ${{matrix.os}}
        run: docker run ${{matrix.image}}

      - name: list container
        run: docker ps -l
```
In this specific example, matrices are used to define a set of combinations for the workflow to run. Let me break down the key components:

```yaml
jobs:
  deploy_on:
    strategy:
      matrix:
        version: [latest]
        os: [ubuntu, windows]
        image: [hello-world, alpine]
    runs-on: ${{matrix.os}}-${{matrix.version}}
```

- `jobs`: Defines a job named "deploy_on."

- `strategy`: Specifies a matrix strategy for the job. The matrix defines different combinations of values for variables. In this case, the matrix has three variables: `version`, `os`, and `image`.

  - `version: [latest]`: Specifies a single version, "latest."
  - `os: [ubuntu, windows]`: Specifies two operating systems, "ubuntu" and "windows."
  - `image: [hello-world, alpine]`: Specifies two Docker images, "hello-world" and "alpine."

- `runs-on: ${{matrix.os}}-${{matrix.version}}`: Specifies the execution environment for the job. The combination of the selected OS and version from the matrix will determine the actual environment.

```yaml
steps:
  - name: run image on ${{matrix.os}}
    run: docker run ${{matrix.image}}

  - name: list container
    run: docker ps -l
```

- `steps`: Defines a series of steps to be executed in the job.

  - The first step (`run image on ${{matrix.os}}`) runs a Docker container using the specified image from the matrix.

  - The second step (`list container`) lists the Docker containers using the `docker ps -l` command.

Overall, this workflow will be triggered on a push event and will run two instances of the job based on the combinations specified in the matrix, using different versions, operating systems, and Docker images.