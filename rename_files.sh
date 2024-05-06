#!/bin/bash

me="${0##*/}"
# echo "$me called"
# echo
# echo "# received arguments ------->  ${@}     "
# echo "# \$1 ----------------------->  $1       "
# echo "# \$2 ----------------------->  $2       "
# echo "# \$3 ----------------------->  $3       "
# echo "# \$4 ----------------------->  $4       "
# echo "# path to me --------------->  ${0}     "
# echo "# parent path -------------->  ${0%/*}  "
# echo "# my name ------------------>  ${0##*/} "
# echo

shopt -s lastpipe
shopt -s nullglob

Usage() {
    echo "Rename files in current directory using regex and sed. @AB"
    echo "Usage:"
    printf "\n    -s \"input file spec/pattern\", use a literal file name or wildcards, e.g. \'*.mp4\'\n"
    echo "    -p \"replacement pattern\", examples: "
    printf "       's/blah_([a-z_]+\.)/\\\U\\\1/g' -- remove 'blah_' and turn the part in brackets to upper case\n"
    printf "       's/[-]{1,1}[\_a-zA-Z0-9\ \-]+(\.[a-zA-Z0-9]{3,4})$/\1/g' -- remove all from dash to extension in file name, but keep extension\n"
    printf "       's/([[:upper:]])/\\\u\L\\\1/g' -- change all upper case chars to lower case\n"
    printf "       's/\\\b(.)/\\\u\\\1/g' -- change first letter of each word to upper case\n"
    printf "       's/(\\\b\w)(\w+)(\.flac)?/\\\U\\\1\\\L\\\2\\\3/g' -- flac files, capitalise the first char of each word in the name, lower-case the\n"
    printf "        rest, leave file extension intact\n"
    printf "       's/(\b[A-Z]|[_][A-Z])([A-Z]+)(\.yml)?/\\\U\\\1\\\L\\\2\\\3/g' -- yaml files, with words separated by spaces and underscores, \n"
    printf "        capitalise the first char of each word in the name and lower-case the rest, leave file extension instact\n"
    printf "    -i \"interactive\" -- if non-empty, the script asks if you want to go ahead, otherwise it renames files without asking\n"
    echo "    --help"
}

if [ $# -lt 3 ]; then
    echo "Insufficient arguments ... "
    echo ""
    Usage
    exit 1
fi

while [ $# -gt 0 ];
do
    case "$1" in
        -s|--file_spec)
            file_spec="$2"
            shift
            ;;
        -p|--replace_pattern)
            replace_pattern="$2"
            shift
            ;;
        -i|--interactive)
            interactive="$2"
            shift
            ;;
        -h|--help|*)
            Usage
            exit 1
            ;;
    esac
    shift
done

if [[ ! -z "$interactive" ]]; then
    echo "Renaming '$file_spec' using the pattern '$replace_pattern'"

    echo "Presss 'y' to continue, 'n' to abort, followed by Return"
    read -r yn

    case $yn in
        [Yy]*) ;;
        [Nn]*) echo "Aborted" ; exit  1 ;;
    esac
fi

for x in $file_spec; do
    # echo "old_name='$x'"
    base_name=$(basename "$x")
    j="$(echo "$base_name" | sed -r "$replace_pattern")"
    # echo "new_name='$j'"

    if [[ "$x" != "$j" ]]; then
       mv "$x" "$(dirname "$x")"/"$j";
       printf "[%s] moved \'%s\' to \'%s\'\n" "$me" "$x" "$j"
    fi
done

