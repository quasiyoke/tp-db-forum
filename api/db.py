import MySQLdb


def get_db():
    return MySQLdb.connect(
        host='localhost',
        user='tp-db-forum',
        passwd='topsecret',
        db='tp-db-forum',
    )

def truncate_all():
    d = get_db()
    cursor = d.cursor()
    cursor.execute('SET FOREIGN_KEY_CHECKS = 0;')
    cursor.execute('TRUNCATE following;')
    cursor.execute('TRUNCATE post;')
    cursor.execute('TRUNCATE thread;')
    cursor.execute('TRUNCATE forum;')
    cursor.execute('TRUNCATE user;')
    cursor.execute('SET FOREIGN_KEY_CHECKS = 1;')
