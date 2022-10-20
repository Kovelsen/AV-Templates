#!/bin/bash

set -e

SYMLINKS=false
COPY=false
TEMPLATE=generiek
FORCE=""
USAGE="Usage: $(basename "$0") [-h] [-f] [-t TEMPLATE] [-l] [-c] dir\n\nCreate a
LaTeX project using one of the default UvA LaTeX templates.\n\n  -c copies
resource files to the working directory, -l creates symbolic links instead.\n -f
ignores existing files and directories.\n -t specifies a template name to use.\n
-h displays this message."

while [[ $# > 0 ]]; do
    case "$1" in
        -t|--template)
            TEMPLATE="$2"
            shift;;
        -f|--force)
            FORCE="-f";;
        -h|--help)
            echo -e $USAGE
            exit 1;;
        -l|--link)
            SYMLINKS=true;;
        -c|--copy)
            COPY=true;;
        *)
            if [[ $# = 1 ]]; then
                TARGET=$1
            else
                echo "Option $1 was not recognised."
                exit 1
            fi;;
    esac
    shift
done

if [ -z "$TARGET" ]; then
    echo "No target directory specified."
    exit 1
fi

if [ -d "$TARGET" ] && [ -z $FORCE ]; then
    echo "Directory already exists."
    exit 1
fi

mkdir -p ${TARGET}

CLASS=`sed -rn 's/\\\documentclass(\[.*\])?\{([a-z\-]+)\}/\2/p' /usr/share/uvalatex/templates/${TEMPLATE}.tex`

if $SYMLINKS ; then
    for x in /usr/share/texmf/tex/latex/uvalatex/images/*.pdf; do ln ${FORCE} -s $x ${TARGET}; done
    ln ${FORCE} -s /usr/share/texmf/tex/latex/uvalatex/classes/${CLASS}.cls ${TARGET}
elif $COPY ; then
    for x in /usr/share/texmf/tex/latex/uvalatex/images/*.pdf; do cp ${FORCE} $x ${TARGET}; done
    cp ${FORCE} /usr/share/texmf/tex/latex/uvalatex/classes/${CLASS}.cls ${TARGET}
fi

cp /usr/share/uvalatex/templates/${TEMPLATE}.tex ${TARGET}

echo "UvA LaTeX project created succesfully in ${TARGET}"
