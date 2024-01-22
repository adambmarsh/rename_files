#!/bin/bash
shopt -s lastpipe

cur_dir="$(pwd)"

Usage() {
    echo "Rename files in current directory using regex and sed. @AB"
    echo "Usage:"
    printf "\n    -s \"input file spec/pattern\", use a literal file name or wildcards, e.g. \'*.mp4\'\n"
    echo "    -p \"replacement pattern\", examples: "
    printf "       's/blah_([a-z_]+\.)/\\\U\\\1/g' -- remove 'blah_' and turn the part in brackets to upper case\n"
    printf "       's/[-]{1,1}[\_a-zA-Z0-9\ \-]+(\.[a-zA-Z0-9]{3,4})$/\1/g' -- remove all from dash to extension in file name, but keep extension\n"
    printf "       's/([[:upper:]])/\\\u\L\\\1/g' -- change all upper case chars to lower case\n"
    printf "       's/\\\b(.)/\\\u\\\1/g' -- change first letter of each word to upper case\n"
    printf "       's/(\w)(\w+)+/\\\U\\\1\\\L\\\2/g' -- make first letter of each word upper case, all other lower case\n"
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
            echo "file_spec=""$file_spec"
            shift
            ;;
        -p|--replace_pattern)
            replace_pattern="$2"
            shift
            ;;
        -h|--help|*)
            Usage
            exit 1
            ;;
    esac
    shift
done

echo "Renaming '$file_spec' using the pattern '$replace_pattern'"
echo "Presss 'y' to continue, 'n' to abort, followed by Return"
read -r yn

case $yn in
    [Yy]*) ;;  
    [Nn]*) echo "Aborted" ; exit  1 ;;
esac

finished=false

find "$cur_dir" -type f | while read -r x; do
    
    if [ "$x" = "$cur_dir"/"$file_spec" ]; then
        # echo "old_name='$x'"
        base_name=$(basename "$x")
        j="$(echo "$base_name" | sed -r "$replace_pattern")"
        # echo "new_name='$j'"
        
        mv "$x" "$(dirname "$x")"/"$j";
        echo "moved ""$x"" to ""$j"
        finished=true
    fi
done
# echo "finished=""$finished"

if [ $finished = true ]; then
    exit 0
fi

find "$cur_dir" -type f | while read -r x; do
    # echo "old_name='$x'"
    base_name=$(basename "$x")
    j="$(echo "$base_name" | sed -r "$replace_pattern")"
    # echo "new_name='$j'"
    
    if [ "$x" = "$j" ]; then
        continue
    fi
    
    mv "$x" "$(dirname "$x")"/"$j";
done

