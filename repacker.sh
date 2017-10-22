#!/bin/bash
#These shell programs are specifically designed for Drupal localization work.

#This program is usefull when you have splitted a module into two files: one 
#contains the strings not translated yet, the other contains the onea already 
#been translated in previous works. Now this program reconstructs the original
#module with dupplicated string ids by collecting them back from previous translations.
#After the untranslated file is translated, you can combine that with this file and you
#reconstructed the original module but with updated translation!
#Please feel free to contact me at <tennom@outlook.com> 

# argument validation
if [[ $# -lt 2 || $# -gt 2 ]]; then
	echo "Enter 2 arguments: 1.id list, 2.translator name"
	exit
fi

# creating the po file. This is subject to change according to resource location
mod_name=`echo $1 | sed "s/.*\/\(.*\)\/dupps$/\1/g"`  #exract the module name from the file path

if [ ! -f modules/"$mod_name"/"$mod_name"_repack.po ]; then
	echo -n > modules/"$mod_name"/"$mod_name"_repack.po
	cat "$2"/header > modules/"$mod_name"/"$mod_name"_repack.po
	echo "Repack po file is created!"
else 
	echo -n > modules/"$mod_name"/"$mod_name"_repack.po
	cat "$2"/header > modules/"$mod_name"/"$mod_name"_repack.po
	echo "Repack po file is recreated!"
fi



function checkFile {
	## 1.an id string; 2.picked file; 3.module name are expected.
	# search the id in specified file.

	##strictly matching the line start and ending as the argument content.
	idStr="^"$1"$"
	# 1st part does the lookup, 2and strip off the po file header since it will be redundant 
	msggrep --msgid -e "$idStr" "$2" | pcregrep -Mo '^msgid ".*"\n(?!msgstr ""\n"Project-Id-Version:)(.*\n)+' > modules/"$3"/tmp_msg
	# checking the size of what was found
	what_found=`cat modules/"$3"/tmp_msg`
	size=${#what_found}
	if [ $size -gt 0 ]
	then
		echo "Found: line $4 and size $size." >&2 #this echo output should be only shown, not to be returned. 
		cat modules/"$3"/tmp_msg >> modules/"$mod_name"/"$mod_name"_repack.po 
		echo "FOUND" #this echo output should be only returned
	else
		echo "NOT FOUND"
	fi
	
}


function pickFile {
	#this expects an input of file array, id string, module name, the counter,
	# number of previously translated files
	#recursively pick a random file to check, among the rest of files

	#to take array as an argument, follow next two lines 
	array_name=$1[@] #just passing the array name, not the array itself
	file_array=("${!array_name}") #get the array by indirect reference
 
	num_files=${#file_array[*]} 
	
	#reassigns needed since this function is a recursion
	id_string=$2
	mod_file=$3
	count=$4
	all_file_num=$5
	
	#recursion base
	if (( $num_files == 0 )); then 
		echo "Translation NOT found; recheck your id string."
		echo "-----------------------------------------------"
		return
	else
		#pick random index from the existing file
		#this is just for performance, even though it's not deterministic
		#statistically, it's good as finding the id string in half of the target files
		rand_index=$((RANDOM%$num_files))
		rand_file=${file_array[$rand_index]}
		#here do the search, if found terminate the recursion, not keep going
		isFound="$(checkFile "$id_string" "$rand_file" "$mod_file" "$count")"

		if [ "$isFound" == "FOUND" ]; then
			echo "In: $rand_file"
			
			echo "No need to check the rest of: $(($num_files-1)) files."
			echo "-----------------------------------------------"
			return
		else 	
			
			echo "$(($(($all_file_num+1))-$num_files)): not in $rand_file"
			
		fi
		
		#prepare to the rest file excluding the one already has been checked.
		new_arr=( "${file_array[@]:0:$rand_index}" "${file_array[@]:(($rand_index+1))}" )
	
		#recur the function on the new array
		pickFile new_arr "$id_string" "$mod_file" "$count" "$all_file_num"
	fi
}

#append all the po file into an array
module_array=();
for f in modules/*.bo.po;
do
	module_array+=($f);
done

array_size=${#module_array[*]} 

counter=0
while IFS='' read -r line || [[ -n "$line" ]]; do
	#collect the corresponding translation for each string id
	counter=$((counter + 1))
	echo ""	
	echo "===================================="
	echo "String ID number: $counter"

	pickFile module_array "$line" "$mod_name" "$counter" "$array_size"
	

			
done < "$1"

exit 0
 
