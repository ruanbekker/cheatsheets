# SFTP Cheatsheet

Connect to server:

```
$ sftp -i ~/.ssh/id_rsa me@sftp.mydomain.com
```

Local working directory:

```
sftp> lpwd
```

Remote working directory:

```
sftp> pwd
```

Listing local files:

```
sftp> lls
```

Listing remote files:

```
sftp> ls
```

Upload a single file:

```
sftp> put file.json
```

Upload a single file to a specific path:

```
sftp> file.json path/to/file.json
```

Upload multiple files:

```
sftp> mput *.json
```

Download a single file:

```
sftp> get file.json
```

Download multiple files:

```
sftp> mget *.json
```

Switching a local directory:

```
sftp> lcd
```

Switching a remote directory:

```
sftp> cd
```

Creating local directory:

```
sftp> lmkdir data
```

Creating remote directory:

```
sftp> mkdir data
```

Deleting remote directory:

```
sftp> rm data
```
