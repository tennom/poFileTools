# Bash scripts for manupulation of GNU Gettext po files. #
Shell Scripts (bash) calculate fees based on word count, detect changes made by translators, combine multiple small po files, find translated ids in new files and etc manage a big localization(translation) work based on GNU po files. Here it's used for Drupal localization. 

## Purposes ##
If you have a big localization work (here we have Drupal), and multiple translators, these tools can do the followings:
1. Find all the msgids in a po file.
```
./idFinder.sh [transtor]/[batch number]/[module name].[locale name].po 

		i.e. ./idFinder.sh tashi/20/contact.bo.po (Tibetan localization)
```
This will creat an id file 'contact.txt'

# still writing up ...#
