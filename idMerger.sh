#!/bin/bash

#NOTE! resource directory here is modules/[MODULE NAME]/ 
#and ids file must be named as module name and placed in module directory

# argument validation
if [[ ! $# -eq 1 ]]; then
	echo "Enter 1 argument: the id list of the module; fomatted in modules/[MODULE NAME]/[MODULE NAME].txt"
	exit
fi

#create two id banks, 1. idBank=core id bank; 2. contribIdBank=non-core module id
if [ ! -f modules/helpers/idBank ]; then
	echo -n > modules/helpers/idBank
	echo "idBank initialized."
fi
if [ ! -f modules/helpers/contribIdBank ]; then
	echo -n > modules/helpers/contribIdBank
	echo "contribIdBank initialized."
fi

mod_dir_name=`echo $1 | sed "s/.*\/.*\/\(.*\)\.txt$/\1/g"`
sort $1 > modules/"$mod_dir_name"/sort_temp
#diff to output unified 5000 lines 
diff -U 5000 modules/helpers/idBank modules/"$mod_dir_name"/sort_temp > modules/"$mod_dir_name"/diff_temp 

#first part copies the diff file| 2and filters lines with +headings| take off the + sign > copy to todo list
cat modules/"$mod_dir_name"/diff_temp | grep -P "^\+[^\+].*" | sed 's/^\+\([^\+].*$\)/\1/g'> modules/"$mod_dir_name"/todoIdsByCore

echo "=========================="
# this prints out the duplicates
echo "Duplicates found in core:"
#cat modules/helpers/diff_temp | grep -P "^\s.*" > dupps
cat modules/"$mod_dir_name"/diff_temp | pcregrep -Mo "^\s\K.*" > modules/"$mod_dir_name"/coreDupps
wc -l modules/"$mod_dir_name"/coreDupps
# keep appending the todoid
echo "------------------------------------"

##I want to leave the idBank as it is with only from the core
## when new ids from non-core modules, they go to contribIdBank
## and get resorted
diff -U 5000 modules/helpers/contribIdBank modules/"$mod_dir_name"/todoIdsByCore > modules/helpers/diff_contribId_todoFromCore
cat modules/helpers/diff_contribId_todoFromCore | grep -P "^\+[^\+].*" | sed 's/^\+\([^\+].*$\)/\1/g'> modules/"$mod_dir_name"/todoIds

echo "Duplicates found in the non-core:"
#cat modules/helpers/diff_temp | grep -P "^\s.*" > dupps
cat modules/helpers/diff_contribId_todoFromCore | pcregrep -Mo "^\s\K.*" > modules/"$mod_dir_name"/Dupps
wc -l modules/"$mod_dir_name"/Dupps
echo "------------------------------------"
echo "Todo ids in $1:"
wc -l modules/"$mod_dir_name"/todoIds
# cat modules/helpers/todoIds >> modules/helpers/idBank
# echo "sorting the ids bank ..."
# sort modules/helpers/idBank > modules/helpers/sorted_idBank
# cat modules/helpers/sorted_idBank > modules/helpers/idBank
echo "=========================================="


#here i Do the contrib id resorting
## backup first
cat modules/helpers/contribIdBank > modules/"$mod_dir_name"/contribIdBank.bak
#append the final todo ids to the bank
cat modules/"$mod_dir_name"/todoIds >> modules/helpers/contribIdBank
#resort
sort modules/helpers/contribIdBank > modules/helpers/cache
cat modules/helpers/cache > modules/helpers/contribIdBank

exit 0
