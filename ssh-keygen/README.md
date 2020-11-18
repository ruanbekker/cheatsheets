# SSH Keygen Cheatsheet

## Usage

Create a SSH Private Key:

```
$ ssh-keygen -f ~/.ssh/mykey -t rsa -C "MyKey" -q -N ""
```

Generate a SSH Public Key from a Private Key:

```
$ ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
```
