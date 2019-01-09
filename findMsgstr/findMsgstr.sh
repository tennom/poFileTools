#!/bin/bash
#input: 1. single msgid, 2. po or pot file where the msgid is found
#output: assoc array of ctxt/s and msgstr/s or empty; single msgid w/ ctxt is saved with key 'base'; array saved in a saved.sh
#This is usefull to get translated string(s) for a given msgid
if [[ ! $# -eq 2 ]]; then
	echo "Enter 2 arguments: a single msgid and po/pot file where msgid is matched."
	exit
fi

pattern=`echo "^""$1""$" | ./escapeRegxE.sh` #escape the regex special chars

getMsgstr() {
    #first pipe takes off the header part of the po file
    #second pipe on msgstr parts are reserved.
    #NOte the $1 below is not the same thing as stdin $1
    echo $( echo "$1" |\
        pcregrep -Mo '(#.+\n)*msgid ".*"\n(?!msgstr ""\n"Project-Id-Version:)(.*\n)+' |\
        pcregrep -Mo 'msgstr.+"\n(".+"\n)*' )
}

#trying to match the pattern and assign the result to content
msggrep -K -e "$pattern" "$2" > tempFile
content=$(cat tempFile)
#cleaning the file to save msgtsr result at the end.
if [ -f "saved.sh" ]; then
    rm saved.sh
fi

declare -A msgArray
if [ ${#content} -gt 0 ]
then
    #check if msgctxt is used
    echo "$content" |  pcregrep -Mo '^msgctxt "\K.+(?="\n)' > ctxtTemp
    ctxt=$(cat ctxtTemp)
    #when msgctxt is found
    if [ ${#ctxt} -gt 0 ]
    then
        baseStr=$( echo "$content" | msggrep -Jv -e "" )
        if [[ "${#baseStr}" -gt 0 ]]
        then
            msgArray["base"]=`getMsgstr "$baseStr"`
        fi

        ctxtArr=()
        while IFS='' read -r line; do
            ctxtArr+=("$line")
        done < ctxtTemp
        #loop thru the ctxts and find msgstr for each ctxt
        for i in "${ctxtArr[@]}"
        do
            strWctxt=$( echo "$content" | msggrep -J -e "$i" )
            # echo "$strWctxt"
            msgArray["$i"]=`getMsgstr "$strWctxt"`
        done
        declare -p msgArray > saved.sh

    else
        #when no msgctxt, return the msgstr part only  
        msgArray["base"]=`getMsgstr "$content"`
        declare -p msgArray > saved.sh  
    fi  
#if not found  
else
    declare -p msgArray > saved.sh
fi
