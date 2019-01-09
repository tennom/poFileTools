# To extract all the msgids into a text file, simply supply the Gettext po/pot.
#
# Scenarios where this script can be used:

* [x] Do word count on the original/English strings
* [x] Customized operations on msgids or msgstrs
* [x] Use it conjunction with Gettext tools: msggrep, msgattrib, msgmerge
# Usage
### Download or clone the script to a folder `cd` to that folder
`
./idFinder.sh FILENAME.po    
`
### As a result, it will print out the string count and you will find the collected msgids in `FILENAME.txt` in modules folder. 
## This has used for Tibetan localization of Drupal and [Shanti UVA](https://mandala-dev.shanti.virginia.edu). 
#### Please file an issue if you find a problem, thanks.

