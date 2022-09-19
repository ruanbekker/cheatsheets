# powershell cheatsheet

## Create

Create a file named `config`:

```powershell
New-Item config -type file
```

## Environment Variables

Show current path environment variable:

```powershell
$env:Path
```

Append to path environment variable:

```powershell
$env:Path += ';C:\Users\<user>\scoop\shims'
```
