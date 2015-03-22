# tp-db-forum

Technopark DB homework project. Web server providing [this API.](https://github.com/s-stupnikov/technopark-db-api)

## Installation

At mysql console:

    > CREATE USER `tp-db-forum`@localhost IDENTIFIED BY "topsecret";
	> CREATE DATABASE `tp-db-forum`;
	> GRANT ALL ON `tp-db-forum`.* TO `tp-db-forum`@localhost;

At shell:

    $ mysql -u"tp-db-forum" -p"topsecret" < all.sql
    $ virtualenv --no-site-packages env
	$ source env/bin/activate
	$ pip install -r requirements.txt
