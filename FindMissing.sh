#!/bin/bash

 bold=`tput bold`
 normal=`tput sgr0`

 # List containing all text based files we want to search
 fileList=$(find . | grep -E ".+(txt|json|xml)")

 # List containing all image files to check verify against
 imageFilelist=$(find . | grep -E ".+(jpg|png|gif|jpeg)")

 # List of images referenced inside of files
 imageList=();
 for fileName in $fileList; do

 results=$(grep -oE '"[a-zA-Z0-9.-]*.(gif|png|jpg|jpeg)"' $fileName | cut -c 2- | rev | cut -c 2- | rev);
 if [ ${#results[@]} -gt 0 ]; then
 # echo ${bold}$fileName${normal};!
 # echo $results;
 # Take results and add them into a list.
 for res in $results; do
 # echo adding $res to list
 imageList+="$res ";
 done;
 fi
 done
 
 for image in $imageList; do
 imageClear=1;
 for filePath in $imageFilelist; do
 # echo "Searching $file to see if $image is a substring"
 res=$(echo "$filePath" | grep -q "$image")
 if [ $? -eq 0 ]; then
 # echo Image $image was found in a file
 # $? = 0
 imageClear=0;

 # as soon as we have found the file we
 # do not need to search for it anymore
 break;
 fi
 done

 if [ $imageClear -eq 1 ]; then
 if [[ $1 = "-v" ]]; then
 echo -e $image "file referenced but not found."
 else
 echo -e $image;
 fi
 fi
 done
