# JavaScript

To run a node environment:

```bash
docker run -it node node
>
```

## Strings and Variables

Set a variable `test`:

```javascript
> var test = 'ok';
> console.log(test);
ok
```

With `var` you can overwrite the value:

```javascript
> var test = 'ok';
> var test = 'ok2';
> console.log(test);
ok2
```

With `const` you cannot as the value remains what it was set initially to:

```javascript
> const test = 'ok';
> const test = 'ok';
Uncaught SyntaxError: Identifier 'test' has already been declared
```

String interpolation:

```javascript
> const name = 'ruan';
> var msg = `my name is ${name}`
> console.log(msg);
my name is ruan
```

With new line characters:

```javascript
> var msg = `my name is:\n- ${name}`
> console.log(msg);
my name is:
- ruan
```

## IF Statements

If, else and else if:

```javascript
> var x = 2;
> if (x == 0) {
  console.log('x is 0');
  } else if (x > 1) {
  console.log('x is more than 1');
  } else {
  console.log('x is probably 1');
}
x is more than 1
```

If statement using multiple conditions:

```javascript
> var event = {'name': 'ruan', 'surname': 'bekker', 'age': 34, 'severity': 'Low', 'skip': false}
> if ((!event.skip && event.name == 'ruan')) {
  console.log('true');
}
true
```

The same as above, but adding OR:

```javascript
> var event = {'name': 'ruan', 'surname': 'bekker', 'age': 34, 'severity': 'Low', 'skip': false}
> if ((!event.skip && event.name == 'frank') || (!event.skip && event.age == 34)) {
  console.log('true');
}
true
```
