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

Configuration per repository:

```bash
git config user.name "Ruan"
git config user.email "me@example.com"
git config commit.gpgsign true
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

## Cherry Picks

Given the scenario that you are creating a new branch `feature/change-website-color` from the `main` branch, but you want to include a recent commit to the branch `feature/fixed-css` to include into your branch. You can use cherry picking.

Create your branch:

```bash
git checkout main
git pull origin main
git checkout -b "feature/change-website-color`
# you done some changes
git commit -m "Changed website color to blue"
```

Now to include the css change:

```bash
git checkout main
git fetch --all
git checkout feature/fixed-css
git log
# copy the commit id
# change to your branch
git checkout feature/change-website-color
git cherry-pick -e <commit-id-that-you-copied>
```

Commit and push to your branch:

```bash
git commit -m "cherry picked css fix"
git push origin feature/change-website-color
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
