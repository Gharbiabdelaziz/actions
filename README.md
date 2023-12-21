## actions:
1. create directory:
```sh
mkdir .github/workflows
touch first-action.yml
```
2. file contenent hand on or tepmlate or combine either (modified tepmlate)
```yml
name: myfirst workflow

on: push
# on: [push, fork]
jobs:
    first_job:
        runs-on: ubuntu-latest
        steps:
            - name: first github action
              run: echo "this is my first github action"
            
            - name: list folder
              run: ls 

            - name: cat file
              run: cat README.md
```
## use actions/checkout@v4
```yml
name: myfirst workflow

on: push
# on: [push, fork]
jobs:
    first_job:
        runs-on: ubuntu-latest
        steps:
            - name: using checkout action
              uses: actions/checkout@v4

            - name: working directory
              run: pwd
              # working dir : /home/runner/work/actions/actions
            - name: nbre proc
              run: nproc
              # 4 proc for free runner vm
            - name: first github action
              run: echo "this is my first github action"
            
            - name: list folder
              run: ls 

            - name: cat file
              run: cat README.md
```
## exec cmd in series:
```yml
name: myfirst workflow

on: push
# on: [push, fork]
jobs:
    first_job:
        runs-on: ubuntu-latest
        steps:
            - name: using checkout action
              uses: actions/checkout@v4

            - name: list and read files
              run: |
                echo "this is my first github action" | tee hello
                ls -lta
                head -n 10 hello
```
install third party
```yml
name: second workflow

on: push
# on: [push, fork]
jobs:
    first_job:
        runs-on: ubuntu-latest
        steps:
            - name: using checkout action
              uses: actions/checkout@v4
            - name: list and read files
              run: |
                echo "this is my first github action" | tee hello
                ls -lta
                sudo apt-get install -y cowsay
                cowsay -f dragon "hello cover me" >>hello
                cat hell
# install third party soft if dont exist like cowsay
```
### exec avec un script shell
```sh
tee script.sh << EOF 
echo "this is my first github action" | tee hello
ls -lta
sudo apt-get install -y cowsay
cowsay -f dragon "hello cover me" >>hello
cat hello
EOF
```
```yml
name: third workflow

on: push
# on: [push, fork]
jobs:
    first_job:
        runs-on: ubuntu-latest
        steps:
            - name: using checkout action
              uses: actions/checkout@v4
            - name: using script shell file
              run: |
                sh ./script.sh
                # chmod +x script.sh
                # ./script.sh
# install third party soft if dont exist like cowsay
```
## executions:
Jobs run in parallel by default, but you can specify dependencies between jobs if you need them to run sequentially. Each job is composed of a series of steps. Steps are individual tasks that are executed sequentially. Each job runs in a fresh virtual environment (isolated from each other jobs), and the workflow can specify the type of runner (e.g., Ubuntu, Windows, macOS) to be used for the job. The runner is responsible for executing the steps in the job.

In the following example, jobs run independently in parallel.
```yml
name: second workflow

on: push
# on: [push, fork]
jobs:
    build_job:
      runs-on: ubuntu-latest
      steps:
          - name: using checkout action
            uses: actions/checkout@v4
          - name: using script shell file
            run: |
              sh ./script.sh
    test_job:
      runs-on: ubuntu-latest
      steps:
        - name: sleep 10
          run: sleep 10
        - name: test
          run: grep -i "dragon" hello
    
    deploy_job:
      runs-on: ubuntu-latest
      steps:
        - name: create file
          run: echo "hello world" >world.txt
        - name: deployment
          run: echo deploy ...........................
```

In the example below, jobs run sequentially and independently. If one job fails, the subsequent jobs are not executed.
```yml
name: second workflow

on: push
# on: [push, fork]
jobs:
    build_job:
      runs-on: ubuntu-latest
      steps:
          - name: using checkout action
            uses: actions/checkout@v4
          - name: using script shell file
            run: |
              sh ./script.sh
    test_job:
      needs: build_job
      runs-on: ubuntu-latest
      steps:
        - name: sleep 10
          run: sleep 10
        - name: test
          run: grep -i "dragon" hello
    
    deploy_job:
      needs: test_job
      runs-on: ubuntu-latest
      steps:
        - name: create file
          run: echo "hello world" >world.txt
        - name: deployment
          run: echo deploy ...........................
```
```yaml

```