#!/bin/bash 

AFTER_SLASH=false
AFTER_ASTER=false
IN_COMMENT=false

while IFS= read -s -n 1 -r char
do
    case $char in 
        '/')
            $IN_COMMENT && $AFTER_ASTER && IN_COMMENT=false
            AFTER_ASTER=false
            AFTER_SLASH=true;
            ;;
        '*')
            $AFTER_SLASH && IN_COMMENT=true
            $AFTER_SLASH || AFTER_ASTER=true
            AFTER_SLASH=false
            ;;
        *)
            AFTER_SLASH=false
            AFTER_ASTER=false
            $IN_COMMENT || [ "$char" == '' ] || echo -n "$char"
            $IN_COMMENT || ([ "$char" == '' ] && echo)
            ;;
    esac
done <$1
