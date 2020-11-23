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

Convert a multiline (newline) public ssh key to a normal public key:

```
$ ssh-keygen -i -f ~/Downloads/key.multiline_pub > ~/Downloads/key.pub
```
