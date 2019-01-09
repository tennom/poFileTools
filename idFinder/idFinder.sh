#!/bin/bash
#input: po/pot file
#output: extracted msgids in modules/[your module name]/[your module nam].txt
# this is useful when you do powerful operations with msggrep, word count and so on
# argument validation
if [[ ! $# -eq 1 ]]; then
	echo "Enter 1 argument: a po/pot file fomatted in [MODULE NAME].bo.po"
	exit
fi
if [ -f "$1" ]
then
	checkSuffix=$( echo "$1" | grep -e ".\+\.bo\.\(po\|pot\)$" )
	if [[ "${#checkSuffix}" -eq 0 ]]
	then
		echo "The suffix po/pot file must be '.bo.po or .bo.pot'"
		exit
	fi
else
	echo "The po you specified is not existed. Please put a valid path to file."
	exit
fi
	
# extracting module name from the po file
moduleName=`echo "$1" | pcregrep -o "(.+/|)\K.+(?=\.bo\.(po|pot))"`

# moduleName=`echo "$1" | sed "s/.*\/.*\/\(.*\)\.bo\.po$/\1/g"`

CombineMultiLines() {
	#Long ids are formed with multiple lines
	#Combine them into single line to be used with GNU's msggrep 
	local id_string=""
	mkdir -p modules/helpers
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
			local header=`echo "$line" | grep -P "^msgid"`
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




echo "making folder: $moduleName"
mkdir -p modules/"$moduleName" 
# put the single line ids in ids txt file
pcregrep -Mo '^msgid "\K.+(?="\n)' $1 > modules/"$moduleName"/"$moduleName".txt
echo "======================================"
echo "Single line ids:"
wc -l modules/"$moduleName"/"$moduleName".txt
echo "--------------------------------------"

pcregrep -Mo '^msgid ""\n(".+"\n)+' $1 > modules/"$moduleName"/multi_"$moduleName"
CombineMultiLines modules/"$moduleName"/multi_"$moduleName" "$moduleName"
echo "======================================="
