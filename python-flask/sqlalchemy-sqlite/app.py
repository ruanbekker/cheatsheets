# More in depth example:
# https://hackersandslackers.com/flask-sqlalchemy-database-models/

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime as dt

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite3'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Student(db.model):
    __tablename__ = 'students'
    id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String(50))
    email = db.Column(db.String(120))
    date_registered = db.Column(db.Date, default=dt.utcnow)

    def __repr__(self):
        return 'User: {user}'.format(user=self.email)

if __name__ == '__main__':
    db.create_all()
    app.run(host='0.0.0.0', port=5000, debug=False)
