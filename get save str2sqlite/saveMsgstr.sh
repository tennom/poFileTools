#!/bin/bash
#NOTE: you need a Sqlite db for this to work and this is the 'save' function and use getMsgstr.sh for 'get'  
#and to me db is a great idea to merge/reconstruct po files with partial/whole existing translations 
###my table name is 'idbank' but you can change it via the varible 'dbname' below
###table schema is
#CREATE TABLE idbank (
#msgid text not null,
#msgstr text,
#msgctx text,
#modules text);
#CREATE UNIQUE INDEX idx_msgid_ctx ON idbank (msgid, msgctx);

###inputs: msgid: pure id string; msgstr: block string with quotes and key words;
#########msgctxt: pure string;module name:name string only with no space or ; symbol
###outputs: saving msg records to database 
if [ ! $# -eq 4 ]; then
	echo "Enter 4 params: msgid,msgstr,msgctx,module name like this; e.g."
    echo "./saveMsgstr.sh '[msgid string]' 'msgstr' 'msgctx' 'aggregator'"
	exit
fi
#to avoid save empty msgstr for a msgid, checking the content
msgstrContent=$(echo "$2" | pcregrep -Mo '"\K.+(?="\n)')
if [[ "${#msgstrContent}" -eq 0 ]]
then
    echo "Attempted to save empty msgstr!"
    echo 'Or the input msgstr is not in msgstr "so and so".'
    exit
fi

dbFile="/home/tbom/Documents/po/core/core-dev.db"
dbName="idbank"

escape4SQL() {
	echo "$1" | sed -e 's/'\''/'\'\''/g' #this will prepend a single quote in front of each single quote
	#sed -e 's/'\'\''/'\''/g' #this will reverse the action above
}
msgID=$( escape4SQL "$1" )
msgSTR=$( escape4SQL "$2" )
msgCTXT=$( escape4SQL "$3" )
modSTR=$( escape4SQL "$4" )

arr=($(sqlite3 "$dbFile" "select count(*),modules from '$dbName' where msgid='$msgID' and msgctx='$msgCTXT'" | 
    tr '|' $' '))

# `sqlite3 core.db "select count(*),modules from idbank where msgid='myid' and msgctx='context'"`
count=${arr[0]}
mods=${arr[1]}

#check if the msgid is not existing, add that into database
if [[ "$count" -eq 0 ]]
then
    sqlite3 "$dbFile" "INSERT INTO '$dbName' VALUES ('$msgID','$msgSTR', '$msgCTXT', '$modSTR')" 
elif [[ "$count" -eq 1 ]]
then
    #check the modules if module name is in list
    modArr=($(echo "$mods" | tr ';' $' '))
    isMod=0
    for mod in "${modArr[@]}"
    do
        if [[ "$mod" = "$modSTR" ]]
        then
            isMod=1
            break
        fi
    done
    #if not, update the modules by appending the module name
    if [[ "$isMod" -eq 0 ]]
    then
        mods="$mods"";$4"
        sqlite3 "$dbFile" "update '$dbName' set modules='$mods' where msgid='$msgID' and msgctx='$msgCTXT'"
        printf "💠"
    else #do nothing since record is existing
        printf "🔯"
    fi
else
    echo "Error! msgid duplication:$count"
    exit
fi
