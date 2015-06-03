import json
import MySQLdb
from api import app
from api import db
from flask import request


@app.route('/db/api/user/create/', methods=['POST', ])
def create():
    req = request.get_json()
    if req is None:
        return json.dumps({
            'code': 2,
            'response': 'Invalid JSON.',
            })
    d = db.get_db()
    cursor = d.cursor()
    try:
        cursor.execute('INSERT INTO `user` (`email`, `username`, `about`, `isAnonymous`, `name`) ' +
            'VALUES (%s, %s, %s, %s, %s);', [
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
    cursor.execute('SELECT `id`, `isAnonymous` FROM `user` WHERE `email` = %s', [
        req['email'],
    ])
    d.commit()
    user = cursor.fetchone()
    return json.dumps({
        'code': 0,
        'response': {
            'about': req['about'],
            'email': req['email'],
            'id': user[0],
            'isAnonymous': bool(user[1]),
            'name': req['name'],
            'username': req['username'],
        }
    })


def get_details(email):
    print email
    d = db.get_db()
    cursor = d.cursor()
    cursor.execute('SELECT `id`, `username`, `about`, `isAnonymous`, `name` FROM `user` ' +
        'WHERE `email` = %s;', [
        email,
    ])
    user = cursor.fetchone()
    if user is None:
        return json.dumps({
            'code': 1,
            'response': 'Such user wasn\'t found.'
            })
    user_id = user[0]
    return json.dumps({
        'code': 0,
        'response': {
            'id': user_id,
            'email': email,
            'username': user[1],
            'about': user[2],
            'isAnonymous': bool(user[3]),
            'name': user[4],
            'followers': get_user_followers(user_id, d),
            'following': get_user_following(user_id, d),
            'subscriptions': [],
        }
    })


def get_user_followers(user_id, d=None):
    if d is None:
        d = db.get_db()
    cursor = d.cursor()
    cursor.execute('SELECT `user`.`email` FROM `following` JOIN `user` ' +
        'ON `user`.`id` = `following`.`follower` WHERE `following`.`followee` = %s;', [
        user_id,
    ])
    d.commit()
    return [user[0] for user in cursor.fetchall()]


def get_user_following(user_id, d=None):
    if d is None:
        d = db.get_db()
    cursor = d.cursor()
    cursor.execute('SELECT `user`.`email` FROM `following` JOIN `user` ' +
        'ON `user`.`id` = `following`.`followee` WHERE `following`.`follower` = %s;', [
        user_id,
    ])
    d.commit()
    return [user[0] for user in cursor.fetchall()]


@app.route('/db/api/user/details/', methods=['GET', ])
def details():
    try:
        return get_details(request.args['user'])
    except KeyError:
        return json.dumps({
            'code': 3,
            'response': 'Required field isnt specified.',
        })
