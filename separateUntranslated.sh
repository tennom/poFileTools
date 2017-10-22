#!/bin/bash
# provide the id list of finished work
# check if the finished ids are found in the moudle
# if true, separate these ids in finishedId; else separate them in todoIds

if [ $# -ne 4 ]; then
	echo "Params: 1.ids, 2. translator, 3. batch number, 4. moudle file excluding the extension."

	exit
fi


if [ ! -f "$2"/"$3"/finishedIds ]; then
	echo -n > "$2"/"$3"/finishedIds
	echo "finishedIds created!"
fi
if [ ! -f "$2"/"$3"/todoIds ]; then
	echo -n > "$2"/"$3"/todoIds
	echo "todoIds created!"
fi

counter=0
while IFS='' read -r line || [[ -n "$line" ]]; do
	##echo "I am a line: $line"
	pattern="^"$line"$"
	msggrep --msgid -e "${pattern}" "$4" | pcregrep -Mo '^msgid ".*"\n(?!msgstr ""\n"Project-Id-Version:)(.*\n)+' > beforeChange
	foundContent=`cat beforeChange`
	size=${#foundContent}
	counter=$((counter + 1))
	
	if [ $size -gt 0 ]
	then
		echo "Found: line $counter and size $size."
		echo "$line" >> "$2"/"$3"/finishedIds
		
	else
		echo "To do: line $counter and size $size." 
		echo "$line" >> "$2"/"$3"/todoIds
	fi
		
done < "$1"

wc -w "$2"/"$3"/finishedIds >finished_temp
wc -w "$2"/"$3"/todoIds >todotemp
read done_words fileName1 <finished_temp
read todowords fileName2 <todotemp

echo -e "\n ******To do size****** \n"
echo -e "Terms done in past: $done_words\n"
echo -e "Terms to do: $todowords\n"


