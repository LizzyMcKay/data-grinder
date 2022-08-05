#!/bin/bash

# a simple script to correct mistakes in filenames. Some filenames have 7 digits in date instead of 1
# wrong : date to be fixed;
# right : new date to replace the wrong one

wrong="2530518"
right="250518"

for i in *; do
	
	if [ "${i:0:7}" == $wrong ]; then
	
		rsname="${i:7:50}"
		fullname="$right$rsname"
	
		printf "\n changing $i to $fullname \n"
		mv "$i" "$fullname"
 
	fi
done
