from flask import Flask, request
import json
app = Flask(__name__)

@app.route('/recommend')
def hello_world():
    query = request.args.get('query')
    print(query)
    result = ['清华大学'] * 10
    return json.dumps(result).encode('utf8')

if __name__ == '__main__':
    app.run()