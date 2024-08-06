# openssl cheatsheet

## Random Strings

Generates a random string of bytes and outputs in hexadecimal format:

```bash
openssl rand -hex 16
```

Generates a random string of bytes and outputs in base64 format:

```bash
openssl rand -base64 24
```

## Generate RSA Private Keys

Generate a new RSA private key of 2048 bits, convert RSA private key to PKCS format, encrypt using DES3 alogirthm and store private key in PEM format:

```bash
openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out my_rsa_key.p8
```

Create a public key from the private key:

```bash
openssl rsa -in my_rsa_key.p8 -pubout -out my_rsa_key.pub
```

