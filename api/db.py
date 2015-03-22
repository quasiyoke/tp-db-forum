import MySQLdb


def get_db():
    return MySQLdb.connect(
        host='localhost',
        user='tp-db-forum',
        passwd='topsecret',
        db='tp-db-forum',
    )
