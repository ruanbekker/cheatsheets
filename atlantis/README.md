# atlantis

Terraform Pull Request Automation - [atlantis](https://www.runatlantis.io/)

## Examples

Plan in the test environment:

```bash
atlantis plan -d 'environments/test'
```

If you had a different workspace:

```bash
atlantis plan -d 'environments/test' -w workspacename
```

Remove state:

```bash
atlantis state -d 'environments/test' rm 'module.acm[0].aws_acm_certificate.this[0]'
```

Atlantis import:

```bash
atlantis import -d 'environments/test' 'module.acm[0].aws_acm_certificate.this[0]' arn:aws:acm:us-east-2:000000000000:certificate/00000000-0000-0000-0000-000000000000
```
