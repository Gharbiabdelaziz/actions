## Skip workflow runs
Workflows that would otherwise be triggered using `on: push` or `on: pull_request` won't be triggered if you add any of the following strings to the commit message in a push, or the HEAD commit of a pull request:

- `[skip ci]`
- `[ci skip]`
- `[no ci]`
- `[skip actions]`
- `[actions skip]`

Alternatively, you can add a `skip-checks` trailer to your commit message. The trailers section should be included at the end of your commit message and be proceeded by two empty lines. If you already have other trailers in your commit message, `skip-checks` should be last. You can use either of the following:
- `skip-checks:true`
- `skip-checks: true`

**Note:** Skip instructions only apply to the `push` and `pull_request` events. For example, adding `[skip ci]` to a commit message won't stop a workflow that's triggered `on: pull_request_target` from running.