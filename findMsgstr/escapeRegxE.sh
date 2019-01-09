#!/bin/bash
#input: strings that need escape special chars
#output: strings with special chars escaped by preceeding a back slash
## when msggrep to find translated result you need to escape special chars in msgid, otherwise not found or error raised
# argument validation
if [ $# -eq 1 ]; then
	input=$1
elif [ ! -t 0 ]; then #check if it's not terminal input, then it's from file or pipe 
	input=$(cat -);
else	
	echo "1 arg is needed."
	exit;
fi
#put the char to escape inside the [] right after s/
#extra caution! quote string vars otherwise echo will do filters on it.
#escaping chars: *,[
echo "$input" | sed -e 's/[*[]/\\&/g'
