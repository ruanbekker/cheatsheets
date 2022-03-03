# rsync cheatsheet

Sync folder in-progress to final:

```
rsync -avz ./in-progress /final
```

Sync the content from in-progress to final:

```
rsync -avz ./in-progress/ /final
```

Sync the content from in-progress to final and exclude the contents from in-progress/junk/

```
rsync -avz --exclude=junk/* ./in-progress/ /final
```

Rsync over SSH:

```
rsync -avz /var/www/ user@1.2.3.4:/var/www/
```

More examples:
- [resource](https://devhints.io/rsync)
