# Bash scripts for manupulation of GNU Gettext po files. #

##Prerequisites##
These scripts intensively use grep (and it's variations), sed, diff, msggrep and etc. If you get "command not found" or "invalid command" errors, these tools may be missing in your environment. These are only tested on Linux, simply should get working on MAC. Windows users may need to install a shell environment and don't know how they work.

##Purposes##
If you have a big localization work (here we have Drupal), and multiple translators, these tools can do the followings:
1. Find all the msgids in a po file.
	\./idFinder.sh \[transtor\]/\[batch number\]/\[module name\]\.\[bo\]\.po i\.e\. \./idFinder\.sh tashi/20/contact\.bo\.po (Tibetan localization)
This will creat a id file 'contact.txt'
2. Find the overlaping terms.
	\.idMerger.sh \[module directory\]/\[module name\]/\[id name \] i\.e\. \./idMerger\.sh contact.txt
This will creat files "todoIds" and "dupplicates"
3. Pack a po file only containing the 'todoIds'

