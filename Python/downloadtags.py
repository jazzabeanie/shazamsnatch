#!/usr/bin/env python

import re
import subprocess

songlist = open('shazamtags.txt', 'r')

for line in songlist:
    tweet = line
    #print tweet
    tweet = tweet.replace(' ', '+')
    #need to use a regular expression to complete the URL. see python koans about_string_manipulation.py
    pattern = re.compile('\+with\+#Shazam.*')
    tweet = re.sub(pattern, '', tweet)
    #print tweet
    tweet = 'https://www.google.com.au/search?q=' + tweet + '&btnI'
    print tweet #this should be an I'm feeling lucky good search URL
#https://stackoverflow.com/questions/19728252/python-get-redirected-url-from-googles-i-feel-lucky-and-duckduckgos-im-f
