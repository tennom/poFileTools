# These two scripts will fetch and save Gettext localization data into a Sqlite db
#
# They are useful when you manage huge Gettext localization tasks:
* [x] Tracking duplicated msgids across multiple po files
* [x] Merging partial translations from multiple po files
* [x] Doing db queries on msgids, msgctx, msgstr or locations

# Usage
### Download or clone the script to a folder `cd` to that folder
### Please open the script and read how you create the database and other info
`
./saveMsgstr.sh 'msgid' 'msgstr' 'msgctx' 'module name'   
`
`
./getMsgstr.sh 'msgid' 'msgctx'  
`

## This has been used for Tibetan localization of Drupal and [Shanti UVA](https://mandala-dev.shanti.virginia.edu). 
#### Please file an issue if you find a problem, thanks.