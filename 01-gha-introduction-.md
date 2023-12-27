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
## use actions/download-artifact@v4 -- actions/upload-artifact@v4 :
In GitHub Actions, the use of actions/download-artifact@v4 and actions/upload-artifact@v4 between jobs is a way to share data or artifacts produced by one job with another job in the same workflow. This is particularly useful when you have multiple jobs that need access to the same set of files or information.

the actions/download-artifact@v4 action is employed to retrieve the artifacts (previously uploaded in Job A) and make them available to the subsequent job for further processing or deployment.
```yaml
name: second workflow

on: push
# on: [push, fork]
jobs:
    build_job:
      runs-on: ubuntu-latest
      steps:
          - name: using checkout action
            uses: actions/checkout@v4

          - name: create file
            run: |
              echo "this is my first dragon action" | tee dragon.txt

          - name: upload artifact
            uses: actions/upload-artifact@v4
            with:
              # Name of the artifact to upload.
              name: dragon-file
              # A file, directory or wildcard pattern that describes what to upload required.
              path: dragon.txt

    test_job:
      needs: build_job
      runs-on: ubuntu-latest
      steps:
        - name: download artifact
          uses: actions/download-artifact@v4
          with:
            # Name of the artifact to upload.
            name: dragon-file
            # A file, directory or wildcard pattern that describes what to upload required.
            
        - name: test
          run: grep -i "dragon" dragon.txt
    
    deploy_job:
      needs: test_job
      runs-on: ubuntu-latest
      steps:
        - name: download artifact
          uses: actions/download-artifact@v4
          with:
            # Name of the artifact to upload.
            name: dragon-file
            # A file, directory or wildcard pattern that describes what to upload required.

        - name: read file
          run: head dragon.txt
        
```
During the program's execution, artifacts are generated in the form of a zip file (dragon-file), encapsulating processed data from earlier stages.
