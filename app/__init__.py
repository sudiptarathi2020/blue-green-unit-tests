import os
from flask import Flask

app = Flask(__name__)

if os.getenv('FLASK_ENV') == 'test':
    app.config.from_object('app.config_test')
else:
    app.config.from_object('app.config')

from app import routes



