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
x=0

while (x<=120):
    pythonrequests()
    y = random()*2
    print("Loop: ", x, "/120 Sleeping: ", round(y,2), " Getting: ", url)
    sleep(y)
    x+=1