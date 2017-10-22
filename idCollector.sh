#!/bin/bash

for f in modules/ids/*.txt;
do
	# diff compares ids that finished against the modules ids
		## marks + for new ids, space for the same ids and - for ids only appeared in the idBank
	# next pipe part 2 filters the new ids which are marked with +
	# part 3 removes the heading + mark so that ids are used for organize todo translations.
	# sorting seems to be needed for diff, otherwise it keeps the duplicates
	sort $f > modules/helpers/sort_temp
	diff -U 5000 modules/helpers/idBank modules/helpers/sort_temp > modules/helpers/diff_temp 
	cat modules/helpers/diff_temp | grep -P "^\+[^\+].*" | sed 's/^\+\([^\+].*$\)/\1/g'> modules/helpers/todoIds
	
	# this prints out the duplicates
	echo "Duplicates found in $f:"
	cat modules/helpers/diff_temp | grep -cP "^\s"
	wc -l modules/helpers/todoIds
	# keep appending the todoid
	echo "idBank collected the todo ids of $f."
	cat modules/helpers/todoIds >> modules/helpers/idBank
	echo "sorting the ids bank ..."
	sort modules/helpers/idBank > modules/helpers/sorted_idBank
	cat modules/helpers/sorted_idBank > modules/helpers/idBank
	echo""
	echo "=========================================="
done	 
