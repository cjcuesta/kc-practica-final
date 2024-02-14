'''
Created on Jan 10, 2017

@author: hanif
'''

from curses.panel import update_panels
from flask import Flask, flash, render_template, redirect, url_for, request, session
from module.database import Database
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from flask import Response


app = Flask(__name__)
app.secret_key = "mys3cr3tk3y"
db = Database()

request_counter = Counter('app_requests_total', 'Total number of requests received')
index_counter = Counter('index_request_total', 'Total number of index request received')
add_counter = Counter('add_request_total', 'Total number of add request received')
add_phone_counter = Counter('add_phone_request_total', 'Total number of add_phone request received')
update_counter = Counter('update_request_total', 'Total number of update request received')
update_phone_counter = Counter('update_phone_request_total', 'Total number of update_phone request received')
delete = Counter('delete_request_total', 'Total number of delete request received')
delete_phone_counter = Counter('delete_phone_request_total', 'Total number of delete_phone request received')

@app.route('/')
def index():
    request_counter.inc()
    index_counter.inc()
    data = db.read(None)
    return render_template('index.html', data = data)

@app.route('/add/')
def add():
    request_counter.inc()
    add_counter.inc()
    return render_template('add.html')

@app.route('/addphone', methods = ['POST', 'GET'])
def addphone():
    request_counter.inc()
    add_phone_counter.inc()
    if request.method == 'POST' and request.form['save']:
        if db.insert(request.form):
            flash("A new phone number has been added")
        else:
            flash("A new phone number can not be added")

        return redirect(url_for('index'))
    else:
        return redirect(url_for('index'))

@app.route('/update/<int:id>/')
def update(id):
    request_counter.inc()
    update_counter.inc()
    data = db.read(id)

    if len(data) == 0:
        return redirect(url_for('index'))
    else:
        session['update'] = id
        return render_template('update.html', data = data)

@app.route('/updatephone', methods = ['POST'])
def updatephone():
    request_counter.inc()
    update_panels.inc()
    if request.method == 'POST' and request.form['update']:

        if db.update(session['update'], request.form):
            flash('A phone number has been updated')

        else:
            flash('A phone number can not be updated')

        session.pop('update', None)

        return redirect(url_for('index'))
    else:
        return redirect(url_for('index'))

@app.route('/delete/<int:id>/')
def delete(id):
    request_counter.inc()
    delete.inc()
    data = db.read(id)

    if len(data) == 0:
        return redirect(url_for('index'))
    else:
        session['delete'] = id
        return render_template('delete.html', data = data)

@app.route('/deletephone', methods = ['POST'])
def deletephone():
    request_counter.inc()
    delete_phone.inc()
    if request.method == 'POST' and request.form['delete']:

        if db.delete(session['delete']):
            flash('A phone number has been deleted')

        else:
            flash('A phone number can not be deleted')

        session.pop('delete', None)

        return redirect(url_for('index'))
    else:
        return redirect(url_for('index'))

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), content_type=CONTENT_TYPE_LATEST)

@app.errorhandler(404)
def page_not_found(error):
    return render_template('error.html')

if __name__ == '__main__':
    app.run(port=8181, host="0.0.0.0")
