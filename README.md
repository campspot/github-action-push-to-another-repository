# github-action-push-to-another-repository

Used to push generated files from a directory from Git Action step into another repository on Github. This is a slight modification to the original action by [@cpina](https://github.com/cpina/github-action-push-to-another-repository), by design it requires that you specify a target directory on the destination repository. It will not delete any files on the destination repo.

## Use Case: push compiled hugo sites to other hugo sites so that they become sub-sections

E.g.
1. Repository `your-site` contains all the HUGO static site raw files with a custom template. 
2. Repository `site-sub-section` contains a special section of `your-site` that uses a different HUGO template. 
3. You can compile the static website in `site-sub-section` and push it to `your-site` which in turns gets built by a **CI/CD** pipeline (GitHub or Third Party).

## Inputs
### `source-directory` (argument)
From the repository that this Git Action is executed the directory that contains the files to be pushed into the repository.

### `target-directory` (argument)
This is the directory in the destination repository where the contents of `source-directory` will be copied into.

### `destination-github-username` (argument)
For the repository `https://github.com/cpina/push-to-another-repository-output` is `cpina`. It's also used for the `Author:` in the generated git messages.

### `destination-repository-name` (argument)
For the repository `https://github.com/cpina/push-to-another-repository-output` is `push-to-another-repository-output`

*Warning:* this Github Action currently deletes all the files and directories in the destination repository. The idea is to copy from an `output` directory into the `destination-repository-name` having a copy without any previous files there.

### `user-email` (argument)
The email that will be used for the commit in the destination-repository-name.

### `destination-repository-username` (argument) [optional]
The Username/Organization for the destination repository, if different from `destination-github-username`. For the repository `https://github.com/cpina/push-to-another-repository-output` is `cpina`.

### `target-branch` (argument) [optional]
The branch name for the destination repository, if different from `master`.

### `commit-message` (argument) [optional]
The commit message to be used in the output repository. Optional and defaults to "Update from $REPOSITORY_URL@commit".

The string `ORIGIN_COMMIT` is replaced by `$REPOSITORY_URL@commit`.

### `API_TOKEN_GITHUB` (environment)
E.g.:
  `API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}`

Generate your personal token following the steps:
* Go to the Github Settings (on the right hand side on the profile picture)
* On the left hand side pane click on "Developer Settings"
* Click on "Personal Access Tokens" (also available at https://github.com/settings/tokens)
* Generate a new token, choose "Repo". Copy the token.

Then make the token available to the Github Action following the steps:
* Go to the Github page for the repository that you push from, click on "Settings"
* On the left hand side pane click on "Secrets"
* Click on "Add a new secret" and name it "API_TOKEN_GITHUB"

## Example usage
```yaml
      - name: Pushes to another repository
        uses: darkquasar/github-action-push-to-another-repository@master
        env:
          API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
        with:
          source-directory: 'public'
          destination-github-username: 'darkquasar'
          destination-repository-name: 'your-site'
          user-email: darkquasar@quasarfun.com
```
