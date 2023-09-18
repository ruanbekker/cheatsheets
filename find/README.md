# find cheatsheet

## Examples

To find a file with the name `hello.txt` somewhere in the `~/workspace` directory:

```bash
find ~/workspace -type f -name 'hello.txt'
```

To find any directories with the name `temp` somewhere in the `~/workspace` directory:

```bash
find ~/workspace -type d -name 'temp'
```

To find and delete any folders that starts with `.terraform/providers`:

```bash
find . -type d -name '.terraform' -exec bash -c 'if [ -d "$1/providers" ]; then rm -rf "$1/providers"; fi' bash {} \;
```
