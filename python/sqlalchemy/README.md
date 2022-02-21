# SqlAlchemy

## Using the Text Module

Source:
- https://chartio.com/resources/tutorials/how-to-execute-raw-sql-in-sqlalchemy/

```python
>>> import sqlalchemy
>>> from sqlalchemy import create_engine
>>> from sqlalchemy import Table, Column, Integer, String, MetaData, ForeignKey
>>> from sqlalchemy import inspect
```

```python
>>> metadata = MetaData()
>>> books = Table('book', metadata, Column('id', Integer, primary_key=True), Column('title', String), Column('primary_author', String))
>>> engine = create_engine('sqlite:///books.db')
>>> metadata.create_all(engine)
```

```python
>>> inspector = inspect(engine)
>>> inspector.get_columns('book')
[
  {'name': 'id', 'type': INTEGER(), 'nullable': False, 'default': None, 'autoincrement': 'auto', 'primary_key': 1}, 
  {'name': 'title', 'type': VARCHAR(), 'nullable': True, 'default': None, 'autoincrement': 'auto', 'primary_key': 0}, 
  {'name': 'primary_author', 'type': VARCHAR(), 'nullable': True, 'default': None, 'autoincrement': 'auto', 'primary_key': 0}
]
```

```python
>>> from sqlalchemy.sql import text
>>> with engine.connect() as con:
...     data = ( { "id": 1, "title": "Crushing It", "primary_author": "Gary Vaynerchuck" },{ "id": 2, "title": "Start with Why", "primary_author": "Simon Sinek" })
...     statement = text("""INSERT INTO book(id, title, primary_author) VALUES(:id, :title, :primary_author)""")
...     for line in data:
...         con.execute(statement, **line)
...
<sqlalchemy.engine.cursor.LegacyCursorResult object at 0x10106cf50>
<sqlalchemy.engine.cursor.LegacyCursorResult object at 0x101ed0c50>
```

```python
>>> with engine.connect() as con:
...     rs = con.execute('SELECT * FROM book')
...     for row in rs:
...         print(row)
...
(1, 'Crushing It', 'Gary Vaynerchuck')
(2, 'Start with Why', 'Simon Sinek')
```

## External Resources

- https://auth0.com/blog/sqlalchemy-orm-tutorial-for-python-developers/

