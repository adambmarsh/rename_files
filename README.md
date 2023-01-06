# rename_files #

This is a very small Bash utility that renames files (and directories)
recursively, starting from the current directory.  

The utility uses find to locate files and/or directories and SED to rename them.

## Installation

1. Clone the repository (and optionally either put the cloned directory on the
   system path or copy `replace_files.sh` to a location on the path)
2. chmod +x the file `replace_files.sh`

## Arguments

* The file or files to rename -- you can use wild cards, e.g, "*.*", *.mp3", etc.
* A full SED match/replace pattern, strictly in accordance with what SED
  supports on your system

## Example of usage: 

The example below invokes `rename_files.sh` located in `~/scripts` to remove
characters between one or more spaces preceding a dash and the file extension. For instance, given a file
name "something - or other 1 and 2.txt", this command changes the file name to "something.txt". 
```
~/scripts/rename_files.sh "*.*" 's/[ ]*[-]{1,1}[\_a-zA-Z0-9\ \-]+(\.[a-zA-Z0-9]{3,4})$/\1/g'
```


## Status

6 Jan 2023 First draft, tested on Manjaro Linux and Ubuntu.

## Copyright

Copyright Adam Bukolt

Note that the copyright refers to the code and scripts in this repository and
expressly not to any third-party dependencies or the Calibre application.

## License

MIT
