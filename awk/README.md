# awk

## Examples

### Second word in a string

If you want to only display a certain piece of string, like the second word:

```bash
echo "one two three" | awk '{print $2}'
```

Will return `two`

### Removing the second column

If we have a csv file:

```csv
2023-08-31 13:40:44,19.90,66.30
2023-08-31 13:41:45,19.90,66.10
2023-08-31 13:42:46,19.90,66.10
```

And we want only the first and third column:

```bash
cat data.csv | awk -F, 'BEGIN {OFS=FS} {print $1, $3}'
```
