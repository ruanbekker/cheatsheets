# git cheatsheet

## Config

Set globals:

```
# git config --global --edit
```

Then your config should look like:

```
$ cat ~/.gitconfig
[user]
	name = Ruan Bekker
	email = <user>@<domain>
```

## Fetch Remote Branches

Fetch all remote branches:

```bash
git fetch --all 
```

Fetch a single branch:

```bash
git fetch origin <local-branch-name>:<remote-branch-name>
```

## Display branch

Display branch for gitref:

```
$ git --no-pager  branch -a --contains 0000000000000000000000000000000000000
  remotes/origin/dev
```

Display as only the branch name:

```
$ git --no-pager  branch -a --contains 0000000000000000000000000000000000000 | rev | cut -d '/' -f1 | rev
dev
```

List local all branches:

```bash
$ git branch -a
```

## Display directory path

Show the current working directory:

```bash
$ git rev-parse --show-toplevel
```

## Merge master into your branch

Sync your branch with the latest changes in master:

```bash
$ git checkout master
$ git pull origin master
$ git checkout feature/one
$ git merge master
$ git push origin feature/one
```

## Delete branches

Delete a local branch:

```bash
$ git branch -D branch-name 
```

## Tags

Create a tag from main, checkout main and sync:

```bash
git checkout main
git pull origin main
```

Create a tag called `snapshot-20230525`:

```bash
git tag snapshot-20230525
```

Push up the tag:

```bash
git push origin snapshot-20230525
```

List all tags with a prefix:

```bash
git tag --sort=-version:refname | grep "release-*"
```

List the previous release (current being 0.55.0):

```bash
git tag --sort=-version:refname | grep "release-*" | sed -n '2p'
# release-0.54.0
```

## Unstage changes

If you have accidentally commited changes, you can unstage them:

```bash
git restore --staged modules/asg/variables.tf
```


## External Cheatsheets

- https://gist.github.com/mkhairi/405c4afa2fedb7328695a7a73ef49074
