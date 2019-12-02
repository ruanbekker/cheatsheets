## External Resources:
- https://devhints.io/vim

## Copy Paste

Copying Lines:

```
on the line that you want to duplicate
yyp
```

Copy a Block:

```
v (for visual mode)
direction arrows to highlight
y (to copy)
i (insert mode) move to the desired area
esc
p
```

## Delete

Deleting a Line:

```
On the line that you want to delete
dd
```

Deleting everything below the cursor:

```
dG
```

Deleting everything above the cursor:

```
dH
```

Deleting 10 Lines below the cursor:

```
10dd
```

Delete the first 4 characters of every line:

```
:%s/^.\{0,4\}//

eg.

>>> class HashTable:
...     def __init__(self):
...         self.size = 256
...         self.slots = [None for i in range(self.size)]
...         self.count = 0

after:

class HashTable:
    def __init__(self):
        self.size = 256
        self.slots = [None for i in range(self.size)]
        self.count = 0
```

## Replace Characters:

Norm Function: Find/Replace

The dataset:

```
123. 123
233. 123

Apply:

:%norm f.C,
```

Result:

```
123,
233,
```

Commenting Lines:

```
shift + v
move down until the line you want to comment out
shift + I
Enter the character (#)
Esc
```

Search and Replace (replace true with false):

```
:%s/true/false/
press enter
```
