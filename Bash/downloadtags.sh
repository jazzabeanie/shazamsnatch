#!/usr/bin/env bash
sed s/' #whatatune.*'//g <../shazamtags.txt >curllinks.sh #remove everything after "with #whatatune" and creates new file. Overwrites??
sed -i -- s/'^'/'youtube '/ curllinks.sh # adds "youtube" to the start of the line to increase search accuracy.
#There might be a possiblity of adding a !youtube bang to the start of the search. Not sure if this is compatible with I'm Feeling Ducky though.
sed -i -- s/' '/'+'/g ./curllinks.sh #remove spaces
sed -i -- s/'^'/'https\:\/\/duckduckgo\.com\/\?q\=\%5C'/ curllinks.sh # add the start of the Duck Duck Go "I'm feeling ducky" search URL
sed -i -- s/'^'/'curl -Ls -w %{url_effective} '/ curllinks.sh #add the curl command to extract the redirected URL
sed -i -- s/'$'/' >>encodedlinks.txt'/ curllinks.sh #append the end of the line so that when run, the script will append the results of curl to a file.
sed -i -- s/'\&'/'and'/ curllinks.sh #remove special character &
sed -i -- s/'+\-+'/'+'/g curllinks.sh #remove dashes
sed -i -- s/[\(\)]/''/g curllinks.sh #remove parenteses, though I thought you didn't have to escape parentesis, so I'm not sure why this works. 
#todo remove other special characters that will cause sintax error as above with &

#the following lines are my attempt to put the result of each curl on a new line, not sure why it's not working. this is todo.
sed -i -- s/'$'/'\
echo -e "\\n" >>encodedlinks.txt'/ curllinks.sh
#sed -i -- s/'$'/'\
#'/g curllinks.sh 

rm -f encodedlinks.txt #removes existing file (if exists) and silences errors.
touch encodedlinks.txt #creates file for curllinks.sh to append to
chmod 700 curllinks.sh #set executable
./curllinks.sh #executes script
sed -i -- s/'\<html\>.*uddg='/''/g encodedlinks.txt #removes text before encoded URL
sed -i -- 's/'\'');}set.*$//g' encodedlinks.txt # removes test after enconded URL

rm -f decodedlinks.sh #removes file if exists
#decodes each link with the urldecode.sh file
while read LINK 
do
        ./urldecode.sh $LINK >>decodedlinks.sh
done < encodedlinks.txt

sed -i -- s/'^'/'youtube-dl -x '/ decodedlinks.sh #adds the youtube-dl prefix with -x to specify audio.
chmod 700 decodedlinks.sh
brew upgrade youtube-dl
DIR=$(pwd)
cd ~/Desktop #so that files are downloaded to the desktop
$DIR/decodedlinks.sh

echo "If you see this message, then the youtube-dl scipt was successuflly run and the script will now delete the temporary files. Hit return to continue"
read dummy_variable #wait for user input so I can check the encodedlinks.txt file
cd $DIR
rm decodedlinks.sh
rm decodedlinks.sh--
rm encodedlinks.txt
rm encodedlinks.txt--
rm curllinks.sh
rm curllinks.sh--

#todo insert line to add download to log
