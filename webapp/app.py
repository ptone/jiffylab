#!/usr/bin/env python
# coding=utf8

import json
import os
import re
import threading
import time
from unicodedata import normalize

import docker
from flask import Flask, render_template, session, g, redirect, url_for
from flask.ext.bootstrap import Bootstrap
from flask.ext.wtf import Form, TextField

import psutil
import requests

app = Flask(__name__)

app.config['BOOTSTRAP_USE_MINIFIED'] = True
app.config['BOOTSTRAP_USE_CDN'] = True
app.config['BOOTSTRAP_FONTAWESOME'] = True
app.config['SECRET_KEY'] = 'devkey'

CONTAINER_STORAGE = "/usr/local/etc/jiffylab/webapp/containers.json"
SERVICES_HOST = '127.0.0.1'
BASE_IMAGE = 'ptone/jiffylab-base'

initial_memory_budget = psutil.virtual_memory().free  # or can use available for vm

# how much memory should each container be limited to
CONTAINER_MEM_LIMIT = 1024 * 1024 * 100
# how much memory must remain in order for a new container to start?
MEM_MIN = CONTAINER_MEM_LIMIT + 1024 * 1024 * 20

app.config.from_object(__name__)
app.config.from_envvar('FLASKAPP_SETTINGS', silent=True)

Bootstrap(app)

docker_client = docker.Client(base_url='unix://var/run/docker.sock',
                  version='1.6',
                  timeout=10)

lock = threading.Lock()


class ContainerException(Exception):
    """
    There was some problem generating or launching a docker container
    for the user
    """
    pass


class UserForm(Form):
    # TODO use HTML5 email input
    email = TextField('Email', description='Please enter your email address.')


@app.before_request
def get_current_user():
    g.user = None
    email = session.get('email')
    if email is not None:
        g.user = email

_punct_re = re.compile(r'[\t !"#$%&\'()*\-/<=>?@\[\\\]^_`{|},.]+')


def slugify(text, delim=u'-'):
    """Generates a slightly worse ASCII-only slug."""
    result = []
    for word in _punct_re.split(text.lower()):
        word = normalize('NFKD', word).encode('ascii', 'ignore')
        if word:
            result.append(word)
    return unicode(delim.join(result))


def get_image(image_name=BASE_IMAGE):
    # TODO catch ConnectionError - requests.exceptions.ConnectionError
    for image in docker_client.images():
        if image['Repository'] == image_name and image['Tag'] == 'latest':
            return image
    raise ContainerException("No image found")
    return None


def lookup_container(name):
    # TODO should this be reset at startup?
    container_store = app.config['CONTAINER_STORAGE']
    if not os.path.exists(container_store):
        with lock:
            json.dump({}, open(container_store, 'wb'))
        return None
    containers = json.load(open(container_store, 'rb'))
    try:
        return containers[name]
    except KeyError:
        return None


def check_memory():
    """
    Check that we have enough memory "budget" to use for this container

    Note this is hard because while each container may not be using its full
    memory limit amount, you have to consider it like a check written to your
    account, you never know when it may be cashed.
    """
    # the overbook factor says that each container is unlikely to be using its
    # full memory limit, and so this is a guestimate of how much you can overbook
    # your memory
    overbook_factor = .8
    remaining_budget = initial_memory_budget - len(docker_client.containers()) * CONTAINER_MEM_LIMIT * overbook_factor
    if remaining_budget < MEM_MIN:
        raise ContainerException("Sorry, not enough free memory to start your container")



def remember_container(name, containerid):
    container_store = app.config['CONTAINER_STORAGE']
    with lock:
        if not os.path.exists(container_store):
            containers = {}
        else:
            containers = json.load(open(container_store, 'rb'))
        containers[name] = containerid
        json.dump(containers, open(container_store, 'wb'))


def forget_container(name):
    container_store = app.config['CONTAINER_STORAGE']
    with lock:
        if not os.path.exists(container_store):
            return False
        else:
            containers = json.load(open(container_store, 'rb'))
        try:
            del(containers[name])
            json.dump(containers, open(container_store, 'wb'))
        except KeyError:
            return False
        return True

def add_portmap(cont):
    if cont['Ports']:
        # a bit of a crazy comprehension to turn:
        # Ports': u'49166->8888, 49167->22'
        # into a useful dict {8888: 49166, 22: 49167}
        cont['portmap'] = dict([(p['PrivatePort'], p['PublicPort']) for p in cont['Ports']])

        # wait until services are up before returning container
        # TODO this could probably be factored better when next
        # service added
        # this should be done via ajax in the browser
        # this will loop and kill the server if it stalls on docker
        ipy_wait = shellinabox_wait = True
        while ipy_wait or shellinabox_wait:
            if ipy_wait:
                try:
                    requests.head("http://{host}:{port}".format(
                            host=app.config['SERVICES_HOST'],
                            port=cont['portmap'][8888]))
                    ipy_wait = False
                except requests.exceptions.ConnectionError:
                    pass

            if shellinabox_wait:
                try:
                    requests.head("http://{host}:{port}".format(
                            host=app.config['SERVICES_HOST'],
                            port=cont['portmap'][4200]))
                    shellinabox_wait = False
                except requests.exceptions.ConnectionError:
                    pass
            time.sleep(.2)
            print 'waiting', app.config['SERVICES_HOST']
        return cont


def get_container(cont_id, all=False):
    # TODO catch ConnectionError
    for cont in docker_client.containers(all=all):
        if cont_id in cont['Id']:
            return cont
    return None


def get_or_make_container(email):
    # TODO catch ConnectionError
    name = slugify(unicode(email)).lower()
    container_id = lookup_container(name)
    if not container_id:
        image = get_image()
        cont = docker_client.create_container(
                image['Id'],
                None,
                hostname="{user}box".format(user=name.split('-')[0]),
                mem_limit=CONTAINER_MEM_LIMIT,
                ports=[8888, 4200],
                )

        remember_container(name, cont['Id'])
        container_id = cont['Id']

    container = get_container(container_id, all=True)

    if not container:
        # we may have had the container cleared out
        forget_container(name)
        print 'recurse'
        # recurse
        # TODO DANGER- could have a over-recursion guard?
        return get_or_make_container(email)

    if "Up" not in container['Status']:
        # if the container is not currently running, restart it
        check_memory()
        docker_client.start(container_id, publish_all_ports=True)
        # refresh status
        container = get_container(container_id)
    container = add_portmap(container)
    return container


@app.route('/', methods=['GET', 'POST'])
def index():
    try:
        container = None
        form = UserForm()
        print g.user
        if g.user:
            # show container:
            container = get_or_make_container(g.user)
        else:
            if form.validate_on_submit():
                g.user = form.email.data
                session['email'] = g.user
                container = get_or_make_container(g.user)
        return render_template('index.html',
                container=container,
                form=form,
                servicehost=app.config['SERVICES_HOST'],
                )
    except ContainerException as e:
        session.pop('email', None)
        return render_template('error.html', error=e)


@app.route('/logout')
def logout():
    # remove the username from the session if it's there
    session.pop('email', None)
    return redirect(url_for('index'))


if '__main__' == __name__:
    # app.run(debug=True, host='0.0.0.0')
    pass


