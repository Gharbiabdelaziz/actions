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
                cat hello
# install third party soft if dont exist like cowsay
```