# sed cheatsheet

## Replace content

Let's say you want to change values in a file and assuming the file is:

```bash
$ cat .env
DB_USER=admin
DB_PASS=__DB_PASS__
```

And we want to substitute `__DB_PASS__` with a variable, we would do:

```bash
$ sed 's/__DB_PASS__/secret/g' .env
```

We ran it without `-i` which wont make changes to the file, as it will only show you the proposed changed values, when you want to write it:

```bash
$ sed -i 's/__DB_PASS__/secret/g' .env
```

If we had the value in our environment as `MYPASSWORD=secret`, we can do:

```bash
$ sed -i "s/__DB_PASS__/${MYPASSWORD}/g" .env
```

If you are on MacOSx, you will need to pass `-i ''`:

```bash
$ sed -i '' "s/__DB_PASS__/${MYPASSWORD}/g" .env
```

## Remove blank lines

Assume you have a file like:

```bash
$ cat file.cfg
[defaults]
key1=val1
key2=val2

key3=val3
```

And you want to remove the blank line:

```bash
$ sed -i '/^$/d' file.cfg
```
