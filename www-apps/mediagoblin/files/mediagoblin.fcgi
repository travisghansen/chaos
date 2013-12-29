#!/usr/bin/python2.7

# Written in 2011 by Christopher Allan Webber
#
# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any
# warranty.
# 
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software. If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.

from paste.deploy import loadapp
from flup.server.fcgi import WSGIServer

CONFIG_PATH = '/etc/mediagoblin/paste.ini'

## Uncomment this to run celery in "always eager" mode... ie, you don't have
## to run a separate process, but submissions wait till processing finishes
# import os
# os.environ['CELERY_ALWAYS_EAGER'] = 'true'

def launch_fcgi():
    ccengine_wsgi_app = loadapp('config:' + CONFIG_PATH)
    WSGIServer(ccengine_wsgi_app).run()

if __name__ == '__main__':
    launch_fcgi()
