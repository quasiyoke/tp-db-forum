import json
import MySQLdb
from api import app
from api import db
from flask import request


@app.route('/db/api/clear/', methods=['POST', ])
def clear():
    db.truncate_all()
    return json.dumps({
        'code': 0,
        'response': 'OK',
      })
