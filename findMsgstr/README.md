# This script gets a msgstr linked with a specified msgid from a po file. 
#
# They are useful when you:
* [x] save gettext msgs for future use
* [x] track changes/status in msgstr translations 
* [*] check existance of a translation but it will not work when msgids contain newline char '\n'. I can't find a way escape '\n' in msgid.

# Usage
### Download or clone the script to a folder `cd` to that folder
```bash
./idMsgstr.sh 'msgid' FILENAME.po    
```
### As a result, it will save all the records in an associative array in saved.sh. Keys are the msgctx and ones with no msgctx, saved with the key 'base' 
#
### Then, if you `cat saved.sh`, you will find the result in it. You may `source ./saved.sh` to use the array var `$msgArray` in your script.
### If you wanna unset the sourced `$msgArray` after used, please do `unset -v msgArray`.
### I will use this script to find all the ids in a msgid text file in [matchId.sh](../matchIds/).
#
#### This has been used for Tibetan localization of Drupal and [Shanti UVA](https://mandala-dev.shanti.virginia.edu). 
#### Please file an issue if you find a problem, thanks.