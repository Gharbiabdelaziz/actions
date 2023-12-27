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