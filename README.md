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

            - name: working directory
              run: |
                pwd
                nproc
                echo "this is my first github action" >hello.txt
                ls -lrta
                cat README.md 
```