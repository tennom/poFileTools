#!/bin/bash
#NOTE: you need a Sqlite db for this to work and this is the 'get' function and use saveMsgstr.sh for 'save' 
#and to me db is a great idea to merge/reconstruct po files with partial/whole existing translations 
###my table name is 'idbank' but you can change it via the varible 'dbname' below
###table schema is
#CREATE TABLE idbank (
#msgid text not null,
#msgstr text,
#msgctx text,
#modules text);
#CREATE UNIQUE INDEX idx_msgid_ctx ON idbank (msgid, msgctx);

#inputs: msgid: pure id string; msgctxt: pure string;
#outputs: data records matches the input or 'NOTFD' when not found
#this is useful when getting the translated strings from db
if [ ! $# -eq 2 ]; then
	echo "Enter 2 params: msgid,msgctx; e.g."
    echo "./saveMsgstr.sh '[msgid string]' 'msgctx'"
	exit
fi

dbFile="/home/tbom/Documents/po/core/core.db"
dbName="idbank"
#this escape single ' for slqite, otherwise sqlite will raise error
escape4SQL() {
	echo "$1" | sed -e 's/'\''/'\'\''/g' #this will prepend a single quote in front of each single quote
}
#this reverse the escape of single ' from slqite, otherwise escaped ' will not match the real msgid
reverseEscape() {
	echo "$1" | sed -e 's/'\'\''/'\''/g' #this will reverse the action above
}

msgID=$( escape4SQL "$1" )
msgCTXT=$( escape4SQL "$2" )

result=$(sqlite3 "$dbFile" "select msgstr from '$dbName' where msgid='$msgID' and msgctx='$msgCTXT'")
if [[ "${#result}" -gt 0 ]]
then
    reverseEscape "$result"
else
    echo "NOTFD"
fi
