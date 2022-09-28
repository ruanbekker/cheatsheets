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

## Display directory path

Show the current working directory:

```bash
$ git rev-parse --show-toplevel
```

## External Cheatsheets

- https://gist.github.com/mkhairi/405c4afa2fedb7328695a7a73ef49074
