import requests, os
from time import sleep
from random import random
from random import seed

seed(1)
url = os.environ.get('SPLUNK_TEST_URL')

def pythonrequests():
    try:
        requests.get(url)
    except requests.exceptions.RequestException as err:
        print(err)
x=1

while x:
    pythonrequests()
    y = random()*2
    print("Getting: ", url, " Sleeping: ",y)
    sleep(y)