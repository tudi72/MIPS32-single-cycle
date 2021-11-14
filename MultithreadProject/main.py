import os

import requests
import webbrowser
import csv
from datetime import datetime
from math import *
import time


def deg_min_sec(degree=0.0):
    if type(degree) != 'float':
        try:
            degree = float(degree)
        except:
            return 0
    minutes = degree % 1.0 * 60
    seconds = minutes % 1.0 * 60

    return str('%s°%s\'%s"' % (int(floor(degree)), int(floor(minutes)), seconds))


header = ['timestamp', 'datetime', 'latitude', 'longitude']

# getting data from the international space station and putting it in json file

# loading the current location of the ISS in real-time
while True:
    if os.path.exists("position.csv"):
        file = open("position.csv","a")
        writer = csv.writer(file)
    else:
        file = open("position.csv", "a")
        writer = csv.writer(file)
        writer.writerow(header)

    response = requests.get("http://api.open-notify.org/iss-now.json")
    result = response.json()

    # extract the ISS location
    timestamp = result['timestamp']
    human_date = datetime.fromtimestamp(timestamp)
    location = result['iss_position']
    latitude = deg_min_sec(location['latitude'])
    longitude = deg_min_sec(location['longitude'])
    row = [str(timestamp), human_date, latitude, longitude]
    print(row)
    writer.writerow(row)
    time.sleep(5)
    file.close()

# closing the file and opening the resulted csv file
