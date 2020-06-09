import requests
import sys
import argparse
import os
from bs4 import BeautifulSoup

PATH = os.environ['USERPROFILE'] +  os.path.sep + 'Desktop' + os.path.sep


def requests_start_url(start_url):
    try:
        response = requests.get(start_url)
        html = response.text
        return html
    except requests.RequestException:
        print('Whoopps! Error')
        return None
 
 
def find_photo_url(requests_url):
    soup = BeautifulSoup(requests_url, 'lxml')
    photo_url = soup.find("meta", property="og:image")
    return photo_url["content"]
 
 
def downloader(photo_url, fileType):
    photo_name = photo_url[-25:-6]
    requests_url = requests.get(photo_url)
    f = open(PATH + photo_name + fileType, 'ab')
    f.write(requests_url.content)
    f.close()
 
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-l', type=str)
    parser.add_argument('-x', type=str)
    args = parser.parse_args()
    requests_url = requests_start_url(args.l)
    photo_url = find_photo_url(requests_url)
    downloader(photo_url, args.x)
main()