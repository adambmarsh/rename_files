#!/bin/sh

if [[ -z $1 ]]; then
    echo "File name pattern cannot be empty."
    echo "Use a literal file name or wildcards, e.g. '*.mp4'"
    exit 1
fi 
if [[ -z $2 ]]; then
    echo "Replacement pattern (regex) cannot be empty."
    echo "Use SED syntax to specify the pattern to match and the replacement. Examples:"
    echo "  's/blah_([a-z_]+\.)/\U\1/g' -- remove 'blah_' and turn the part in brackets to upper case"
    echo "  's/[-]{1,1}[\_a-zA-Z0-9\ \-]+(\.[a-zA-Z0-9]{3,4})$/\1/g' -- remove all from dash to extension in file name, but keep extension"
    exit 2
fi

echo "Renaming '$1' using the pattern '$2'"
read -p "Press Y to continue or any other key to abort ... " -n 1 -r

echo -e "\n"

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

for i in $(find . -name $1);
do
    # echo "old_name=$i"
    j="$(echo $i | sed -E "$2")"
    # echo "new_name=$j"

    if [[ "$i" == "$j" ]]; then
        continue
    fi
    
    mv "$i" "$j";
done
