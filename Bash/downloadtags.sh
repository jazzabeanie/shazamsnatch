#!/usr/bin/env bash
# some good info about sed: https://unix.stackexchange.com/questions/32907/what-characters-do-i-need-to-escape-when-using-sed-in-a-sh-script

#todo remove curllinks.sh, curllinks.sh--, encodedlinks.txt and encodedlinks.txt-- files.
sed s/' with #Shazam.*'//g <../shazamtags.txt >curllinks.sh #remove everything after "with #Shazam" and creates new file. Overwrites??
sed -i -- s/' '/'+'/g ./curllinks.sh #remove spaces
#todo - add the word youtube to the start of the search to reduce the chances of lyrice coming up in search results. There might be a possiblity of adding a !youtube bang to the start of the search. Not sure if this is compatible with I'm Feeling Ducky though.
sed -i -- s/'^'/'https\:\/\/duckduckgo\.com\/\?q\=\%5C'/ curllinks.sh # add the start of the Duck Duck Go "I'm feeling ducky" search URL
sed -i -- s/'^'/'curl -Ls -w %{url_effective} '/ curllinks.sh #add the curl command to extract the redirected URL
sed -i -- s/'$'/' >>encodedlinks.txt'/ curllinks.sh #append the end of the line so that when run, the script will append the results of curl to a file.
sed -i -- s/'\&'/'and'/ curllinks.sh #remove special character &
#todo remove other special characters that will cause sintax error as above with &

#the following lines are my attempt to put the result of each curl on a new line, not sure why it's not working. this is todo.
sed -i -- s/'$'/'\
echo -e "\\n" >>encodedlinks.txt'/ curllinks.sh
#sed -i -- s/'$'/'\
#'/g curllinks.sh 

sed -i -- s/'+\-+'/'+'/g curllinks.sh #remove dashes
sed -i -- s/[\(\)]/''/g curllinks.sh #remove parenteses, though I thought you didn't have to escape parentesis, so I'm not sure why this works. 
rm -f encodedlinks.txt #removes existing file and silences errors.
touch encodedlinks.txt #creates file for curllinks.sh to append to
chmod 700 curllinks.sh #set executable
./curllinks.sh #executes script
#echo "Check the encodedlinks.txt file to see that page information looks ok, then hit return to continue"
#read dummy_variable #wait for user input so I can check the encodedlinks.txt file
sed -i -- s/'\<html\>.*uddg='/''/g encodedlinks.txt #removes text before encoded URL
sed -i -- 's/'\'');}set.*$//g' encodedlinks.txt # removes test after enconded URL



####todo decode URL
###        #https://unix.stackexchange.com/questions/159253/decoding-url-encoding-percent-encoding#159373
###        #https://stackoverflow.com/questions/3728049/using-awk-printf-to-urldecode-text#23406177
###        #https://stackoverflow.com/questions/6250698/how-to-decode-url-encoded-string-in-shell
###        #http://www.commandlinefu.com/commands/view/2285/urldecoding
###        #can this be done using printf? http://wiki.bash-hackers.org/commands/builtin/printf
###        #convert hex to ascii
###sed -e's/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g' | xargs echo -e
##sed -e's/%\([0-9A-F][0-9A-F]\)/\\x\1/g' <encodedlinks.txt >temp
##echo -e "\x41" | awk '{printf "%c\n", $1}'
##sed -e's/%\([0-9A-F][0-9A-F]\)/\\x\1/g' <encodedlinks.txt >temp
##echo -e "http\x3A\x2F\x2Fwww.youtube.com\x2Fwatch\x3Fv\x3DjDplwu9kH9Y" | awk '{printf "%c\n", $1}'
#
##Stu helped me find the urldecode.sh script somewhere on the internodes, eg,
#./urldecode.sh "http%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DJGhoLcsr8GA"
#then I put it to use by looping over the lines according to this page:
#https://stackoverflow.com/questions/11349827/how-do-i-iterate-through-lines-in-an-external-file-with-shell
rm -f decodedlinks.sh
#touch decodedlinks.sh
#echo "cd ~/Desktop" >>decodedlinks.sh
while read LINK 
do
        ./urldecode.sh $LINK >>decodedlinks.sh
done < encodedlinks.txt

sed -i -- s/'^'/'youtube-dl -x '/ decodedlinks.sh # add the start of the Duck Duck Go "I'm feeling ducky" search URL
chmod 700 decodedlinks.sh
brew upgrade youtube-dl
DIR=$(pwd)
cd ~/Desktop
$DIR/decodedlinks.sh
#./decodedlinks.sh

#cd $DIR
#rm decodedlinks.sh
#rm decodedlinks.sh--
#rm encodedlinks.txt
#rm encodedlinks.txt--
#rm curllinks.sh
#rm curllinks.sh--

#todo insert line to add download to log
#todo cd to desktop before running script.
#todo rm unnecesary files after downloading songs.
#./encodedlinks.txt
#after I get the curl command in encodedlinks.txt working, I'll need to trim it down, then decode the url to something that youtube-dl can use.

#now need to get the URL after redirecting from the I'm feeling lucky url generate above. Had problems doing this earlier.
#https://stackoverflow.com/questions/3074288/get-url-after-redirect
#curl -Ls -w %{url_effective} https://duckduckgo.com/?q=%5CAct+Your+Age+by+Bliss+N+Eso | sed s/^.*http/http/g
#http%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DUIK%2DSdrzpqc
#sed -e's/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g' | xargs echo -e
#curl -Ls -w %{url_effective} https://duckduckgo.com/?q=%5CAct+Your+Age+by+Bliss+N+Eso
