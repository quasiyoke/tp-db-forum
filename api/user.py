import json
import MySQLdb
from api import app
from api import db
from flask import request


@app.route('/db/api/user/create/', methods=['POST', ])
def create():
    req = request.get_json()
    d = db.get_db()
    cursor = d.cursor()
    try:
        cursor.execute('INSERT INTO `user` (`email`, `username`, `about`, `isAnonymous`, `name`) VALUES (%s, %s, %s, %s, %s);', [
            req['email'],
            req['username'],
            req['about'],
            req.get('isAnonymous') and '1' or '0',
            req['name'],
        ])
    except KeyError:
        return json.dumps({
            'code': 3,
            'response': 'Required field isnt specified.',
        })
    except MySQLdb.IntegrityError:
        return json.dumps({
            'code': 5,
            'response': 'Such user is already exists.',
        })        
    d.commit()
    
    cursor = d.cursor()
    cursor.execute('SELECT `id` FROM `user` WHERE `email` = %s', [
        req['email'],
    ])
    d.commit()
    row = cursor.fetchone()
    return json.dumps({
        'code': 0,
        'response': {
            'about': req['about'],
            'email': req['email'],
            'id': row[0],
            'isAnonymous': bool(req.get('isAnonymous', False)),
            'name': req['name'],
            'username': req['username'],
        }
    })


def get_details(email):
    d = db.get_db()
    cursor = d.cursor()
    cursor.execute('SELECT `id`, `email`, `username`, `about`, `isAnonymous`, `name` FROM `user` WHERE `email` = %s;', [
        email,
    ])
    row = cursor.fetchone()
    return json.dumps({
        'code': 0,
        'response': {
            'id': row[0],
            'email': row[1],
            'username': row[2],
            'about': row[3],
            'isAnonymous': row[4],
            'name': row[5],
            'followers': [],
            'following': [],
            'subscriptions': 0,
        }
    })


@app.route('/db/api/user/details/', methods=['GET', ])
def details():
    req = request.get_json()
    try:
        return get_details(request.args['email'])
    except KeyError:
        return json.dumps({
            'code': 3,
            'response': 'Required field isnt specified.',
        })
