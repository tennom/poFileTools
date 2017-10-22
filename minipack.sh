#!/bin/bash


if [ $# -lt 3 ]; then
	echo "Enter params not less than 3: 1.id list, 2.translator name, 3.batch number and 4.whatever for originalFile"
	exit
elif [ $# -eq 3 ]; then
	extension="A"
	fileName="changedFile"
else
	extension="B"
	fileName="originalFile"
fi
if [ ! -f "$2"/"$3"/"$2""$3"$extension.po ]; then
	echo -n > "$2"/"$3"/"$2""$3""$extension".po
	cat "$2"/header > "$2"/"$3"/"$2""$3""$extension".po
	echo "Affected content is extracted!"
fi
mod_dir_name=`echo $4 | sed "s/.*\/.*\/\(.*\)\.txt$/\1/g"`
echo -n > modules/"$mod_dir_name"/not_found
counter=0
while IFS='' read -r line || [[ -n "$line" ]]; do
	##strictly matching the line start and ending as the input lines
	pattern="^"$line"$"
	##first part is for finding the line as a msgid in the gettext file and pipe it to second
	##second is for excluding gettext msg headings
	msggrep -K -e "$pattern" "$2"/"$3"/"$fileName".po | pcregrep -Mo '^msgid ".*"\n(?!msgstr ""\n"Project-Id-Version:)(.*\n)+' > revision
	
	
	##size=${#revision}
	contents=$(cat revision)
	size=${#contents}
	counter=$((counter + 1))
	if [ $size -gt 0 ]
	then
		cat revision >> "$2"/"$3"/"$2""$3""$extension".po
	else 
		echo "Errors: $line"
		echo "$line" >> modules/"$mod_dir_name"/not_found
	fi
	echo "line: $counter and the size is $size"
	size=0
		
done < "$1"
##pcregrep -Mo '^msgid ".*"\n(?!msgstr "")(.*\n)+'
##pcregrep -Mo '^msgid ""\n".+"\n(.*\n)+'
##pcregrep -Mo '^msgid ".+"\n(.*\n)+'
##pcregrep -Mo '^msgid ".+"\n(.+\n)+?'
