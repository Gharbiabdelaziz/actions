# use matrices:
- [use matrices:](#use-matrices)
  - [before using matrix:](#before-using-matrix)
  - [after using matrices](#after-using-matrices)
  - [add include and exlude in matrix:](#add-include-and-exlude-in-matrix)
  - [fail fast and max parallel](#fail-fast-and-max-parallel)
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
## add include and exlude in matrix:
Certainly! Here's a concise explanation of the `include`, `exclude`, and `matrix` sections in the GitHub Actions workflow YAML file:

- `matrix`: Defines a matrix of values for specified variables. It allows you to run a job with different configurations based on the specified matrix. In the example, the matrix includes different operating systems (`os`) and Docker images (`image`).

- `include`: Specifies configurations from the matrix that should be included and run. In the example, the job is set to run on `ubuntu-20.04` and use the `amd64/alpine` image when the conditions specified in the `include` section are met.

- `exclude`: Specifies configurations from the matrix that should be excluded and not run. In the example, the job is set to exclude running on the `windows-latest` OS and using the `alpine` image.

These sections help customize the workflow to run on specific configurations while excluding others, providing flexibility and control over the execution environment.
```yaml
name: deploy

on: push

jobs:
  deploy_on:
    runs-on: ${{ matrix.os }}

    strategy:
      matrix:
        # combination 03*02 except 01 and add 01
        os: [ubuntu-latest, ubuntu-20.04, windows-latest]
        image: [hello-world, alpine]
        exclude:
        - os: windows-latest
          image: alpine
        include:
        - os: ubuntu-20.04
          image: amd64/alpine

    steps:
      - name: run image on ${{ matrix.os }}
        run: docker run ${{ matrix.image }}
      - name: list container
        run: docker ps -l
```
## fail fast and max parallel

1. **`fail-fast: false`**:
   - By default, the `fail-fast` strategy is set to `true`. When `fail-fast` is set to `true`, the job execution stops as soon as one of the parallel jobs fails. This is useful when you want to quickly identify and address issues in your CI/CD pipeline.

   - Setting `fail-fast` to `false` means that even if one parallel job fails, the other parallel jobs will continue to execute. This can be beneficial in scenarios where you want to collect results from multiple parallel processes, even if some of them encounter failures.

   Example:
   ```yaml
   strategy:
     fail-fast: false
     max-parallel: 2
   ```

2. **`max-parallel: 2`**:
   - The `max-parallel` option specifies the maximum number of parallel jobs that can run simultaneously. In the provided example, `max-parallel` is set to `2`, meaning that up to two parallel jobs can execute concurrently.

   - This is useful for optimizing resource utilization and speeding up the overall execution of a workflow by allowing multiple tasks to be performed simultaneously. However, it's important to consider the available resources and dependencies of the jobs when setting this value.

   Example:
   ```yaml
   strategy:
     fail-fast: false
     max-parallel: 2
   ```

Combining both options in the `strategy` section allows you to control the concurrency of job execution and the handling of failures. With `fail-fast` set to `false`, the workflow continues to execute other parallel jobs even if one fails, and `max-parallel` limits the number of concurrent jobs to 2 in this specific example. This can be particularly beneficial for scenarios where you have independent tasks that can run concurrently, and you want to collect results from all tasks regardless of individual failures.
```yaml
name: deploy

on: push

jobs:
  deploy_on:
    runs-on: ${{ matrix.os }}
    # jobs are 06 in matrix add 01 to them one fails (alpine image on windows)
    # max executed 2 in parrallel
    strategy:
      # 
      fail-fast: false
      max-parallel: 2
      matrix:
 
        os: [ubuntu-latest, ubuntu-20.04, windows-latest]
        image: [hello-world, alpine]
        include:
        - os: ubuntu-20.04
          image: amd64/alpine

    steps:
      - name: run image on ${{ matrix.os }}
        run: docker run ${{ matrix.image }}

      - name: list container
        run: docker ps -l
```