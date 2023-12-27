In the provided example GitHub Actions workflow, the `timeout-minutes` property is used to set a maximum time limit for the execution of a job or a specific step within that job. This helps prevent workflows from running indefinitely and consuming unnecessary resources.

Let's break down the example workflow:

```yaml
name: Example Workflow

on:
  push:
    branches:
      - main

jobs:
  example-job:
    timeout-minutes: 2  # Set a maximum time limit for the entire job to 2 minutes
    runs-on: ubuntu-latest

    steps:
      - name: Run Sleep Command
        run: sleep 600
        timeout-minutes: 1  # Set a maximum time limit for this step to 1 minute
```

1. **Workflow Trigger:**
   - The workflow is triggered on a push event to the `main` branch.

2. **Job Configuration:**
   - The job named `example-job` is configured to run on the latest version of Ubuntu.
   - The `timeout-minutes: 2` property is set for the entire job, indicating that the entire job should complete within 2 minutes.

3. **Job Steps:**
   - The job contains a single step named "Run Sleep Command."
   - The `run` attribute specifies the command to be executed, in this case, `sleep 600` which causes the job to pause for 600 seconds (10 minutes).
   - The `timeout-minutes: 1` property is set specifically for this step, overriding the job's timeout. This means that if the sleep command takes more than 1 minute to complete, the step will be forcefully terminated.

In summary, the workflow has an overall time limit of 2 minutes for the entire job. However, the specific step "Run Sleep Command" has its own timeout of 1 minute, meaning that if that step takes longer than 1 minute, it will be forcefully terminated, even though the overall job timeout is set to 2 minutes.