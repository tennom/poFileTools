#!/bin/bash

if [ $# -ne 3 ]; then
	echo "Params: 1.ids, 2.translator and 3.batch number"
	exit
fi


if [ ! -f "$2"/"$3"/improvedIds ]; then
	echo -n > "$2"/"$3"/improvedIds
	echo "improvedIds created!"
fi
if [ ! -f "$2"/"$3"/keptSameIds ]; then
	echo -n > "$2"/"$3"/keptSameIds
	echo "keptSameIds created!"
fi

counter=0
while IFS='' read -r line || [[ -n "$line" ]]; do
	##echo "I am a line: $line"
	pattern="^"$line"$"
	msggrep --msgid -e "${pattern}" "$2"/"$3"/"$2""$3"B.po | pcregrep -Mo '^msgid ".*"\n(?!msgstr ""\n"Project-Id-Version:)(.*\n)+' > beforeChange
	msggrep --msgid -e "${pattern}" "$2"/"$3"/"$2""$3"A.po | pcregrep -Mo '^msgid ".*"\n(?!msgstr ""\n"Project-Id-Version:)(.*\n)+' > afterChange
	
	diff_result=$(diff <( cat beforeChange ) <( cat afterChange ))
	
	size=${#diff_result}
	counter=$((counter + 1))
	echo "line: $counter and diff size $size"
	

	if [ $size -gt 0 ]
	then
		echo "$line" >> "$2"/"$3"/improvedIds
	else
		echo "$line" >> "$2"/"$3"/keptSameIds
	fi
		
done < "$1"

wc -w "$2"/"$3"/improvedIds >imp_temp
wc -w "$2"/"$3"/keptSameIds >kepttemp
read imp_words fileName1 <imp_temp
read keptwords fileName2 <kepttemp
fees=$(echo "scale=2; $imp_words * 0.4 + $keptwords * 0.02" | bc -l)
echo -e "\n ******RESULT****** \n"
echo -e "You translated/improved: $imp_words\n"
echo -e "You checked/verified: $keptwords\n"
echo -e "Payrates: 0.4RMB/en for improved ones and 0.02RMB for verified ones, \n 0 for left blanks \n so we will need to pay you: $fees RMB"


