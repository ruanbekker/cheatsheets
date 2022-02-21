# More in depth example:
# https://hackersandslackers.com/flask-sqlalchemy-database-models/

from flask import Flask, make_response, render_template, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime as dt

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite3'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Student(db.Model):
    __tablename__ = 'students'
    id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String(50))
    email = db.Column(db.String(120))
    date_registered = db.Column(db.Date, default=dt.utcnow)

    def __repr__(self):
        return 'User: {user}'.format(user=self.email)

@app.route('/seed', methods=['GET'])
def student_seeds():
    new_student = Student(
        id=1,
        name="Ruan",
        email="ruan@example.com",
        date_registered=dt.now()
    )
    db.session.add(new_student)  
    db.session.commit()  
    return make_response(f"{new_student} successfully created!")

@app.route('/', methods=['GET'])
def student_records():
    students = Student.query.all()
    student_list = []
    for student in students:
        student_list.append({"name": student.name, "email": student.email, "date_registered": student.date_registered})
    return jsonify(student_list)

if __name__ == '__main__':
    db.create_all()
    app.run(host='0.0.0.0', port=5000, debug=True)
