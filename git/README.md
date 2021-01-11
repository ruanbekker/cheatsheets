# git cheatsheet

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

## External Cheatsheets

- https://gist.github.com/mkhairi/405c4afa2fedb7328695a7a73ef49074
