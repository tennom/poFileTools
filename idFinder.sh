#!/bin/bash
# this is useful when you want to extract translation ids from a po file to a txt file.
# so that you can do word count 
# argument validation
if [[ ! $# -eq 1 ]]; then
	echo "Enter 1 argument: Po file downloaded from Drupal, fomatted in [MODULE NAME].bo.po"
	exit
fi

CombineMultiLines() {
	#Long ids are formed with multiple lines
	#Combine them into single line to be used with GNU's msggrep 
	local id_string=""
	echo -n > modules/helpers/longIds
	while read line
	  do
		# if detected an empty line, copy the combined id to list
		# and reset a new id
		if [ -z "${line}" ]; then
			echo "$id_string" >> modules/helpers/longIds
			local id_string=""
			
		else
			# replace all the quotes and headings
			local header=`echo $line | grep -P "^msgid"`
			local headerSize=${#header}
			if [ $headerSize -gt 0 ] 
				then 
				local cleanString=`echo "$line" | sed 's/^msgid "\(.*\)"$/\1/g'`
			else
				local cleanString=`echo "$line" | sed 's/^"\(.*\)"$/\1/g'`
			fi

			local id_string="$id_string$cleanString"
		fi

	done < "$1"
	echo "Multi-line ids:"
	wc -l modules/helpers/longIds
	cat modules/helpers/longIds >> modules/"$2"/"$2".txt
}


# extracting module name from the po file
moduleName=`echo $1 | sed "s/.*\/.*\/\(.*\)\.bo\.po$/\1/g"`

echo "making folder: $moduleName"
mkdir modules/"$moduleName" 
# put the single line ids in ids txt file
pcregrep -Mo '^msgid "\K.+(?="\n)' $1 > modules/"$moduleName"/"$moduleName".txt
echo "======================================"
echo "Single line ids:"
wc -l modules/"$moduleName"/"$moduleName".txt
echo "--------------------------------------"

pcregrep -Mo '^msgid ""\n(".+"\n)+' $1 > modules/"$moduleName"/multi_"$moduleName"
CombineMultiLines modules/"$moduleName"/multi_"$moduleName" "$moduleName"
echo "======================================="
