## Concourse Cheatsheets

- https://cheatsheet.dennyzhang.com/cheatsheet-concourse-a4


Login to your Team:

```
$ fly -t ci-teamx login -c https://ci.domain.com -n teamx
```

List your targets:

```
$ fly targets
name       url                    team             expiry
ci         https://ci.domain.com  teamy            n/a
ci-teamx   https://ci.domain.com  teamx            Tue, 15 Oct 2019 20:42:34 UTC
```
