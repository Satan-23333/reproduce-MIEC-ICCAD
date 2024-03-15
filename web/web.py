from flask import Flask, request, render_template, jsonify
import os

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/get-content')
def get_content():
    if os.path.exists('../vcompile.txt'):
        with open('../vcompile.txt', 'r') as file:
            content = file.read()
        return jsonify({'content': content})
    return jsonify({'content': '文件不存在'})

@app.route('/save-input', methods=['POST'])
def save_input():
    text = request.form['text']
    with open('input.txt', 'w') as file:
        file.write(text)
    return jsonify({'status': 'success'})

@app.route("/robots.txt")
def robots_txt():
    return "User-agent: *\nDisallow: /"

if __name__ == '__main__':
    app.run(debug=True)
