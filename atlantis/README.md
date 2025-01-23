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

Plan against a target:

```bash
atlantis plan -d environments/test -w workspacename -- -target=module.environment.module.vpc
```

Plan a delete:

```bash
atlantis plan -d environments/test -w workspacename -- -destroy
```

Plan a targeted delete:

```bash
atlantis plan -d environments/test -w workspacename --auto-merge-disabled -- -destroy -target=module.eks -target=module.vpc
```

Run a apply without merging:

```bash
atlantis apply --auto-merge-disabled
```

Remove state:

```bash
atlantis state -d 'environments/test' rm 'module.acm[0].aws_acm_certificate.this[0]'
```

Atlantis import:

```bash
atlantis import -d 'environments/test' 'module.acm[0].aws_acm_certificate.this[0]' arn:aws:acm:us-east-2:000000000000:certificate/00000000-0000-0000-0000-000000000000
```

Atlantis replace (taint):

```bash
atlantis plan -d environments/test -w workspacename -- -replace='module.env.some_resource.this'
```
