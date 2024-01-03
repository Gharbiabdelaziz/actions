## condition to run steps:
Below is an example of a GitHub Actions workflow YAML file with three steps, where the second step is conditional on the success of the previous step:

```yaml
name: Example Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v2

    - name: Step 1
      run: echo "This is Step 1"

    - name: Step 2
      if: success()
      run: echo "This is Step 2, running only if Step 1 is successful"

    - name: Step 3
      run: echo "This is Step 3"
```

In this example:

- The workflow is triggered on each push to the main branch (`on: push: branches: - main`).
- The job (`build`) runs on the latest version of Ubuntu (`runs-on: ubuntu-latest`).
- The first step checks out the repository (`uses: actions/checkout@v2`).
- Step 1 simply echoes a message.
- Step 2 uses the `if: success()` condition, which means it will only run if the previous step (Step 1) is successful.
- Step 3 is a regular step that will run regardless of the outcome of the previous steps.

You can customize the commands inside each step based on your requirements. The `if: success()` condition ensures that Step 2 only runs if Step 1 is successful. You can adjust conditions based on other outcomes, such as failure (`if: failure()`) or specific outcomes of previous steps.

## all conditions:
Certainly! GitHub Actions provides several conditions you can use in the `if` statement. Here are some common conditions:

- `success()`: Runs the step only if all previous steps were successful.
- `failure()`: Runs the step only if any of the previous steps failed.
- `cancelled()`: Runs the step only if any of the previous steps were cancelled.
- `always()`: Runs the step regardless of the outcome of previous steps.
- `changed('path')`: Runs the step only if the specified files or directories have changed.
- `github.event_name == 'pull_request'`: Runs the step only for pull request events.
- `github.event_name == 'push'`: Runs the step only for push events.
- `github.event_name == 'schedule'`: Runs the step only for scheduled events.
- `github.actor == 'username'`: Runs the step only if the actor (user) triggering the workflow matches the specified username.
- `matrix.variable == 'value'`: Runs the step only if the specified matrix variable has a particular value.

Here's an example using some of these conditions:

```yaml
name: Example Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v2

    - name: Step 1
      run: echo "This is Step 1"

    - name: Step 2 on Success
      if: success()
      run: echo "This is Step 2, running only if Step 1 is successful"

    - name: Step 3 on Failure
      if: failure()
      run: echo "This is Step 3, running only if Step 1 failed"

    - name: Step 4 on Specific Event
      if: github.event_name == 'pull_request'
      run: echo "This is Step 4, running only for pull requests"

    - name: Step 5 on Actor
      if: github.actor == 'username'
      run: echo "This is Step 5, running only if triggered by 'username'"

    - name: Step 6 on Matrix Variable
      if: matrix.variable == 'value'
      run: echo "This is Step 6, running only if matrix variable is 'value'"
```

You can mix and match these conditions based on your workflow requirements. Adjust the conditions to suit your specific needs.

## condition , continue on error:

Certainly! In a YAML file for a GitHub Actions workflow, you can use the `continue-on-error` option to allow the workflow to continue even if a particular step fails. Additionally, you can use the `if` condition to specify when a step should run. Here's an example:

```yaml
name: Example Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v2

    - name: Step 1
      run: echo "This is Step 1"

    - name: Step 2 (Continue on Error)
      continue-on-error: true
      run: echo "This is Step 2, it might fail"
    
    - name: Step 3 (Conditional)
      if: success() && github.event_name == 'push'
      run: echo "This is Step 3, running only on successful push events"

    - name: Step 4 (Always Run)
      run: echo "This is Step 4, it will always run"

    - name: Step 5 (Conditional on Failure)
      if: failure()
      run: echo "This is Step 5, running only if any previous step failed"
```

In this example:

- `Step 2` has `continue-on-error: true`, which means that even if it fails, the workflow will continue to the next steps.

- `Step 3` has a condition specified with `if: success() && github.event_name == 'push'`, meaning it will only run on successful push events.

- `Step 5` has a condition specified with `if: failure()`, meaning it will only run if any of the previous steps failed.

Feel free to customize the steps and conditions based on your specific workflow requirements.

## identify step with id then use it as condition in step later:
```yaml

name: solar system

on:
    workflow_dispatch: 
    push: 
        branches: 
            - 'main'
            - 'feature/v1'
env:
    MONGO_URI: 'mongodb+srv://supercluster.d83jj.mongodb.net/superData'
    MONGO_USERNAME: ${{vars.MONGO_USERNAME}}
    MONGO_PASSWORD: ${{secrets.MONGO_PASSWORD}}
jobs:
    unit-testing:
        name: unit testing
        strategy:
          matrix:
            nodejs_version: [18]
            os: [ubuntu-latest]
        runs-on: ${{matrix.os}}
        steps:
            - name: checkout repository
              uses: actions/checkout@v1
            - name: setup node ${{matrix.nodejs_version}}
              uses: actions/setup-node@v3
              with:
                node-version: ${{matrix.nodejs_version}}
            - run: npm install
            - run: npm test
              id: run_test_on_nodejs 
# identify steps with id identifier
            - name: upload artifact
              uses: actions/upload-artifact@v3
              with:
                name: mocha-test-result
                path: test-results.xml
              if: failure() && (steps.run_test_on_nodejs.outcome == 'failure' || steps.run_test_on_nodejs.outcome == 'success')
# run this step if step with id identied failed or successeded
    code_coverage:
      name: code coverage
      runs-on: ubuntu-latest
      steps:
          - name: checkout repository
            uses: actions/checkout@v1
          - name: setup node 18
            uses: actions/setup-node@v3
            with:
              node-version: 18
          - run: npm install
          - run: npm run coverage
            continue-on-error: true # protect step from failing
          - name: archive coverage
            uses: actions/upload-artifact@v3
            with:
              name: code-coverage-archive
              path: coverage
              retention-days: 5
# arhive retained for period of time 5 days in our case
            # if: failure() || cancelled()
# cotinue to run archive step if the previous step failed or conceled
```
| Property Name                  | Type    | Description                                                                                               |
|---------------------------------|---------|-----------------------------------------------------------------------------------------------------------|
| steps                           | object  | This context changes for each step in a job. You can access this context from any step in a job. This object contains all the properties listed below.               |
| steps.<step_id>.outputs         | object  | The set of outputs defined for the step. For more information, see "Metadata syntax for GitHub Actions."   |
| steps.<step_id>.conclusion      | string  | The result of a completed step after continue-on-error is applied. Possible values are success, failure, cancelled, or skipped. When a continue-on-error step fails, the outcome is failure, but the final conclusion is success. |
| steps.<step_id>.outcome         | string  | The result of a completed step before continue-on-error is applied. Possible values are success, failure, cancelled, or skipped. When a continue-on-error step fails, the outcome is failure, but the final conclusion is success. |
| steps.<step_id>.outputs.<output_name> | string | The value of a specific output.                                                                          |
