#!/bin/bash


if [ ! $# -eq 2 ]; then
	echo "Enter 2 params: the id text file, po file"
	exit
fi
if [[ -f "$1" && -f "$2" ]]
then
	checkSuffix1=$( echo "$1" | grep -e ".\+\.txt$" )
	checkSuffix2=$( echo "$2" | grep -e ".\+\.\(po\|pot\)$" )

	if [[ "${#checkSuffix1}" -eq 0 || "${#checkSuffix2}" -eq 0 ]]
	then
		echo "The suffixes must be .txt and .po/pot."
		exit
	fi
else
	echo "One or the both of the specified is not existed. Please put a valid path to file."
	exit
fi
	
# extracting module name from the po file
# modname=`echo "$1" | pcregrep -o "(.+/|)\K.+(?=\.txt)"`

# if [ ! -f "$2"/"$3"/"$2""$3"$mod_dir_name.po ]; then
# 	echo -n > "$2"/"$3"/"$2""$3"$mod_dir_name.po
# 	cat "$2"/header > "$2"/"$3"/"$2""$3"$mod_dir_name.po
# 	echo "Affected content is extracted!"
# fi
# #ls is good but doesn't support path specification
# #find 1. specify the path 2. search depth is the same dir 3. search target with not_found 4. direct stderr msgs to /dev/null 5. then count the lines.
# nf_file_count=$( find modules/"$mod_dir_name" -maxdepth 1 -name "not_found*" 2> /dev/null | wc -l )

# case $nf_file_count in
# 0)
# 	nf_file="modules/$mod_dir_name/not_found"
# 	echo -n > modules/"$mod_dir_name"/not_found
# 	#echo "in the case one, $nf_file_count"	
# 	;;
# *)
# 	nf_file="modules/$mod_dir_name/not_found$nf_file_count"
# 	echo -n > modules/"$mod_dir_name"/not_found"$nf_file_count"
# 	echo "not_found$nf_file_count is created."
# 	#echo "in the case two, found $nf_file_count."	
# 	;;
# esac
touch trash/not_found
counter=0
err=0

# while IFS='' read -r line || [[ -n "$line" ]]; do
# EXTRA caution when read is used, because it does more than just reading a line.
printf "["
while IFS='' read -r line; do
	##strictly matching the line start and ending as the input lines
	# str=`./findMsgstr.sh "$line" "$2"`

	./findMsgstr.sh "$line" "$2" #this will save the array in a file named saved.sh
	. ./saved.sh	#source saved.sh to get msgArray
	if [[ "${#msgArray[@]}" -eq 0 ]]
	then 
		err=$((err + 1))
		echo "Error $err:$line"
		echo "$line" >> trash/not_found
	elif [[ "${#msgArray[@]}" -ge 1 ]]
	then
		#here i'm saving to database but you can do any action with the details.
		# for i in "${!msgArray[@]}"
		# do
		# 	./saveMsgstr.sh "$line" "${msgArray["$i"]}" "$i" "$modname"
		# done
		printf  "▓"
	else
		echo "Error from saved.sh"
	fi
	unset -v msgArray #unset the env var
	# echo "$str"
	# if [[ "$str" = "NFD" ]]
	# then
	# 	err=$((err + 1))
	# 	echo "Error $err:$line"
	# 	echo "$line" >> trash/not_found
	# else
	# 	printf  "▓"
	# fi
	counter=$((counter + 1))	
done < "$1"
printf "] done!\n"
echo "----------------------"
echo "All together: $counter done. $err NOT found."
echo "======================="
