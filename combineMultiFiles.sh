#!/bin/bash
# 2 args: 1 translator; 2 batch
# argument validation
if [[ ! $# -eq 2 ]]; then
	echo "Enter 2 arguments: 1.translator name, 2.batch name"
	exit
fi

if [ ! -f "$1"/"$2"/"$1""$2"B.po ]; then
	echo -n > "$1"/"$2"/"$1""$2"B.po
	cat "$1"/header > "$1"/"$2"/"$1""$2"B.po
	echo "bulk file is created!"
fi 


function buildBulkFile {
# get an toid list
# keep appending to the bulk file

	echo -n > modules/"$1"/not_found
	counter=0
	while IFS='' read -r line || [[ -n "$line" ]]; do
		##strictly matching the line start and ending as the input lines
		pattern="^"$line"$"
		##first part is for finding the line as a msgid in the gettext file and pipe it to second
		##second is for excluding gettext msg headings
		msggrep -K -e "$pattern" "$2"/"$3"/"$1".bo.po | pcregrep -Mo '^msgid ".*"\n(?!msgstr ""\n"Project-Id-Version:)(.*\n)+' > revision
	
	
		##size=${#revision}
		contents=$(cat revision)
		size=${#contents}
		counter=$((counter + 1))
		if [ $size -gt 0 ]
		then
			cat revision >> "$2"/"$3"/"$2""$3"B.po
		else 
			echo "Errors: $line"
			echo "$line" >> modules/"$mod_name"/not_found
		fi
		echo "line: $counter and the size is $size"
		size=0
		
	done < "$4"
}

for f in "$1"/"$2"/*.bo.po;
do

	mod_name=`echo $f | sed "s/.*\/.*\/\(.*\)\.bo.po$/\1/g"`
	echo "======================================="
	echo "Status in $f"
	
	buildBulkFile "$mod_name" "$1" "$2" modules/"$mod_name"/todoIds
	echo "======================================"
	echo ""


done

exit 0
