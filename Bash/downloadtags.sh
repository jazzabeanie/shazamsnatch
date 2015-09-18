#!/usr/bin/env bash
cd ~/Dropbox/Music/whatatune/Bash
while read TWEET
do
        SONG=$(echo $TWEET | sed s/' #whatatune.*'//g) #removes everything after " #whatatune". The tweet should be in the format "song by artist #whatatune etc"
        SONGPLUS=$(echo $SONG | sed s/' '/'+'/g) #replaces + (plus) with spaces
        SEARCHURL='https://duckduckgo.com/?q=%5Cyoutube+'$SONGPLUS #creates an I'm Feeling Ducky search URL
        HEADER=$(curl -Ls -w %{url_effective} $SEARCHURL) #follows the link, extracts the header information, and assigns it to a variable
        #todo remove special characters, &, -, (, ), etc. This step may notactually be necessary
        LINK=$(echo $HEADER | sed s/'\<html\>.*uddg='/''/g) #removes everything before the final destination link
        LINK=$(echo $LINK | sed 's/'\'');}set.*$//g') #removes everything after final destination link
        LINK=$(./urldecode.sh $LINK) #decodes link
        #todo remove the dependancy for the urldecode.sh file. https://stackoverflow.com/questions/890262/integer-ascii-value-to-character-in-bash-using-printf
        CURRENTDIR=`pwd`
        cd ~/Desktop
        youtube-dl -x $LINK #downloads audio from link
        cd $CURRENTDIR
        echo "$SONG, $LINK, $TWEET, `date`" >> downloads.csv
        #todo sort out the double lines issue. This occurs if a video doesn't completely download. Is there any other time where this happens?
        #todo delete line from file
done < ../shazamtags.txt
