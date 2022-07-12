#!/bin/bash

# a script to list all possible combination of rat name and recording date.
# specify the directory to be searched as argument 1
# script prints unique combinations of recording date and rat number to file "combinations.txt"
# written by Adam Hanzlik, 2022

printf "\n I will be searching the following directory: \n $1 \n"

touch combinations.txt
echo "" > combinations.txt

# iterate over Rat 9 to Rat 99
for k in {9..99}
do
	
	if  find $1 | egrep -q ".*at$k.*$" 
	then
		printf "\n running script for Rat_$k"
	else
		printf "\n THERE WAS NO RAT_$k"
		printf "\n "
		continue
	fi
	sleep 2

	declare -a names

	for i in $(find $1 | egrep "[0-9]{5,}.*at$k.*pos$")
	do
		
		# now to put the filenames into an array
		names=(${names[@]} "$i")
		
	done

	printf "\n files related to Rat_$k\n"
	echo "${names[@]}"
	printf "\n"
	sleep 1

	### now any file which is not related to one of the experimental configs (A,A1,A2,B etc...) is not relevant.	
	printf "checking if filename was part of full experiment\n"	
	sleep 2
	# actually we won't be removing unwanted filenames yet, bc bash only has sparse arrays. 
	# we will put the good files into a new array
	declare -a newnames

	for (( i=0;i<=${#names[@]};i++ ))
	do
		#^R to exclude filenames with MARIA in it
		if [[ ! "${names[i]}" =~ .*[^M|I][AB].* ]]
		then
			printf "${names[i]} was NOT part of the experiment, REMOVING FROM LIST \n"
		else
			newnames+=(${names[$i]})
			printf "${names[i]} was part of the experiment \n"
			
		fi
	done
	sleep 2
	
	printf "\n ${#names[@]} filenames in total, out of which ${#newnames[@]} were part of the experiment, KEEPING ${#newnames[@]} IN LIST"
	printf "\n"
	
	for i in ${!newnames[@]}
	do
		printf "\n filename ${newnames[i]} with index $i"
	done

	sleep 2

	### now find the filenames the first 5 digits of which occur mutliple times in names array ~ filenames which are redundant
	#in other words, check if the date of the ith filename matches with date in ((i-1))th filename
	#declare array to save to-be-deleted filename positions into
	declare -a delete
	#also print elements in array for testing purposes
	for (( i=1;i<=${#newnames[@]};i++  ))
	do

		echo ${newnames[i]}
		
		if [ "${newnames[i]:0:5}" == "${newnames[((i-1))]:0:5}" ]
		then
			echo 'match'
			#if the substrings match, save the array position of the ith filename
			delete=(${delete[@]} $i)
		else
			echo 'do not match'
		fi
		printf "\n"

	done

	sleep 2
	
	printf "\nindices of filenames to be deleted: "
	echo "${delete[@]}"
	#delete the filenames which are redundant
	for i in ${delete[@]}
	do
		unset newnames[$i]
	done

	### trim filenames so that they are in <DATE>_<RatNumber> format
	
	len=$(echo ${#newnames[@]})
	printf "I found this many combinations: $len"
	printf "\n" 
	# turn out you can easily iterate over array indices in bash. who could have known 
	printf "filenames (and their indices) which are unique combinations:\n"

	#declare -a trnames
	for i in ${!newnames[@]}
	do
		echo $i
		echo ${newnames[i]} | egrep -o '[0-9]+.*at[0-9]{2}'
		newnames[$i]=$(echo ${newnames[$i]} | egrep -o '[0-9]+.*at[0-9]{2}')
	done

	# write the trimmed and selected filenames to a file
	for i in ${newnames[@]}
	do
		echo $i >> combinations.txt
		printf "\n" >> combinations.txt
	done

	#cleanup after each Rat number
	unset names
	unset newnames
	unset delete
	#unset trnames
	
	sleep 3

done

