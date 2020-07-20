from os import getenv

def get_mesos_host():
    return '{}:{}'.format(getenv('HOST'), getenv('PORT'))
