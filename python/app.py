from flask import Flask, jsonify, make_response, request
from datetime import datetime

server = Flask(__name__)


@server.route('/', methods=['GET'])
def index():
    return 'Hello World.'