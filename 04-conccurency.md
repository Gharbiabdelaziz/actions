## conccurency: 
[GitHub Actions - Using Concurrency](https://docs.github.com/en/actions/using-jobs/using-concurrency)
```yaml
name: Example Workflow

on:
  push:
    branches:
      - main
  concurrency:
    group: conccurency-fw-level
    cancel-in-progress: true
    # cancel-in-progress set to true


jobs:
  build:
    runs-on: ubuntu-latest
    # cancel-in-progress set to false
    # A job in this workflow is waiting for conccurency-job-level to complete before running if it's running already
    concurrency:
      group: conccurency-job-level
      cancel-in-progress: false 

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Build
        run: sleep 600
```
In the provided GitHub Actions YAML file, concurrency settings are applied at both the workflow level and the job level. Let's break down the configuration:

```yaml
name: Example Workflow

on:
  push:
    branches:
      - main
  concurrency:
    group: conccurency-fw-level
    cancel-in-progress: true
```

**Workflow Level Concurrency:**
- The `concurrency` key is set at the workflow level using the `on` section.
- `group: conccurency-fw-level` specifies a concurrency group identifier for the workflow.
- `cancel-in-progress: true` indicates that if a new workflow run is triggered and an existing run with the same concurrency group is in progress, the existing run should be canceled.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    
    concurrency:
      group: conccurency-job-level
      cancel-in-progress: false

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Build
        run: sleep 600
```

**Job Level Concurrency:**
- The `concurrency` key is set at the job level within the `jobs` section.
- `group: conccurency-job-level` specifies a concurrency group identifier for the job.
- `cancel-in-progress: false` indicates that if a new job of the same type (with the same concurrency group) is triggered while an existing job is in progress, the new job will not cancel the existing one will wait untill the named conccurency finished.

**Explanation:**
- The workflow level concurrency (`conccurency-fw-level`) controls how many workflow runs can be triggered concurrently. If a new run is triggered and there's already a run in progress with the same concurrency group, the existing run will be canceled (`cancel-in-progress: true`).
  
- The job level concurrency (`conccurency-job-level`) controls how many jobs of the same type within the workflow can run concurrently. If a new job is triggered and there's already a job of the same type in progress with the same concurrency group, the new job will not cancel the existing one (`cancel-in-progress: false`).

This configuration provides a balance between canceling in-progress workflow runs for the same workflow and allowing multiple jobs of the same type within the workflow to run concurrently without canceling each other.