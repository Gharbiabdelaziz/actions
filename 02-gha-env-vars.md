## env vars at all level (workflow, jobs, steps): 
In a GitHub Actions YAML file (`*.yml`), you can use environment variables at different levels such as workflow, jobs, and steps. Here's an example and an explanation for each level:

```yaml
name: CI Workflow

on:
  push:
    branches:
      - main

env:
  WORKFLOW_ENV_VAR: workflow_value

jobs:
  build_job:
    runs-on: ubuntu-latest

    env:
      JOB_ENV_VAR: job_value

    steps:
    
    - name: Display Environment Variables
      run: |
        echo "Workflow Level: $WORKFLOW_ENV_VAR"
        echo "Job Level: $JOB_ENV_VAR"
        echo "Step Level: $STEP_ENV_VAR"
      env:
        STEP_ENV_VAR: step_value
```

Explanation:

1. **Workflow Level:**
   - Environment variables defined at the workflow level apply to all jobs and steps within that workflow. In the example above, `WORKFLOW_ENV_VAR` is defined at the top level under `env:`.

2. **Job Level:**
   - Environment variables defined at the job level apply to all steps within that job. In the example, `JOB_ENV_VAR` is defined under the `build` job.

3. **Step Level:**
   - Environment variables defined at the step level apply only to that specific step. In the example, `STEP_ENV_VAR` is defined under the `Display Environment Variables` step.

By using environment variables at different levels, you can control the scope of the variables based on your needs. Workflow-level variables are global for the entire workflow, job-level variables are specific to each job, and step-level variables are localized to individual steps.

This hierarchical structure allows you to manage and share variables effectively across different parts of your GitHub Actions workflow.

---

## env vars at repo level:
When writing a GitHub Actions workflow YAML file (`*.yml`), you can use environment variables at the `repository` level to define values that are accessible across all jobs and steps within the workflow. Additionally, you can use secrets to store sensitive information securely, such as API keys or passwords.

Here's a brief explanation and an example of using environment variables and secrets at the repository level in a GitHub Actions workflow YAML file:

1. **Environment Variables at Repo Level:**
   - Environment variables set at the repository level can be accessed by all jobs and steps in your workflow.
   - These variables are defined in the repository settings on the GitHub website.

   **Example:**
   ```yml
   name: My Workflow

   on:
     push:
       branches:
         - main

   jobs:
     build:
       runs-on: ubuntu-latest

       steps:
         - name: Display Environment Variable
           run: echo ${{vars.MY_VARIABLE}} #---------vars-------
   ```

2. **Secrets at Repo Level:**
   - Secrets are encrypted environment variables that are stored in the GitHub repository settings.
   - They can be referenced in your workflow YAML file and are masked in job logs for security.

   **Example:**
   ```yml
   name: My Workflow

   on:
     push:
       branches:
         - main

   jobs:
     deploy:
       runs-on: ubuntu-latest

       steps:
         - name: Deploy to Production
           run: ./deploy.sh
           env:
             API_KEY: ${{ secrets.PRODUCTION_API_KEY }} #---------secret-------
   ```

   In this example, the `PRODUCTION_API_KEY` is a secret stored in the GitHub repository settings, and its value is retrieved from the secret using the `${{ secrets.SECRET_NAME }}` syntax.
