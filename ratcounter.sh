#!/bin/bash

# a script to list all possible combination of rat name and recording date.
# specify the directory to be searched as argument 1
# script prints unique combinations of recording date and rat number to file "combinations.txt"
# written by Adam Hanzlik, 2022

printf "\n I will be searching the following directory: \n $1 \n"

touch combinations.txt
echo "" > combinations.txt

# iterate over Rat 9 to Rat 99
for k in {18..99}
do
	#delimiter for cosemtic purposes
	printf "\n -------------------------------------------- \n"

	if  ls $1 | egrep -q ".*at$k.*$" 
	then
		printf "\n running script for Rat_$k"
	else
		printf "\n THERE WAS NO RAT_$k"
		printf "\n "
		continue
	fi
	sleep 2

	declare -a names

	for i in $(ls $1 | egrep "[0-9]{5,}.*at$k.*pos$")
	do
		
		# now to put the filenames into an array
		names=(${names[@]} "$i")
		
	done

	printf "\n files related to Rat_$k\n"
	echo "${names[@]}"
	printf "\n"
	sleep 1

	### now any file which is not related to one of the experimental configs (A,A1,A2,B etc...) is not relevant.	
	printf "checking if filename was part of experiment\n"	
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
	printf "\n"

	### now find the filenames the first 5 digits of which occur mutliple times in names array ~ filenames which are redundant
	#in other words, check if the date of the ith filename matches with date in ((i-1))th filename
	#declare array to save to-be-deleted filename positions into
	declare -a delete
	#also the number of files with that specific date == number of recording session made on that day will be counted.
	sessioncounter=0;
	# print the firs element in newnames array before the loop begins for cosmetic purposes 
	#printf "\n ${newnames[0]} \n"

	for (( i=0;i<$(( ${#newnames[@]}-1 ));i++  ))
	do
		
		printf "\n ${newnames[$i]} "

		if [ "${newnames[i]:0:5}" == "${newnames[((i+1))]:0:5}" ]
		then
	
			sessioncounter=$(( $sessioncounter+1 ))
			printf "\n This file corresponds to the $sessioncounter th recording session on that day \n"

			printf "Recorded on the same day as \n"
			#if the substrings match, save the array position of the ith filename
			delete=(${delete[@]} $(( $i+1 )))

		else
			printf "\n RECORDED ON A DIFFERENT DAY THAN \n"
			# if there were less than 7 sessions that day, the full experiment could not have benn conducted since it has 7 sessions.
			# such filename is irrelevant

			#still sessioncounter needs to be incremented
			sessioncounter=$(( sessionocunter+1 ))

			if (( $sessioncounter <= 6 ))
			then
	 			printf "\n Only $(( $sessioncounter )) sessions recorded that day, that's not enough for full experiment \n"
				
				delete2=$(( $i-$sessioncounter ))
				printf "\n deleting also file ${newnames[$delete2]} with index $delete2 from the list \n"
				sleep 2
			fi
			#set sessioncounter back to 0
			sessioncounter=0

		fi
		# print the last element of the array as the previous loop ended at ${#newnames[@]}-1
		printf "\n ${newnames[$(( $i+1 ))]} \n"
		
		printf "\n"

	done

	# check for cases when there are very few days in which a rat was recorded. I'm lazy af 
		if (( ${#newnames[@]} <= 7 ))
			then
	 			printf "\n Only $(( $sessioncounter+1 )) sessions recorded that day, that's not enough for full experiment \n"
				
				delete2=$(( $i-$sessioncounter ))
				printf "\n deleting also file ${newnames[$delete2]} with index $delete2 from the list \n"
			else
				printf "\n statement not working \n"
		fi


	sleep 2
	
	printf "\n indices of filenames to be deleted because redundant: "
	echo "${delete[@]}" 
	printf "\n indices of filenames to be deleted because nt enough sessions: "
	echo "${delete2[@]}"
	#delete the filenames which are redundant
	for i in ${delete[@]}
	do
		unset newnames[$i]
	done
	
	#delete aslo filenames which are not part of the full 7-session experiment
	for i in ${delete2[@]}
	do
		unset newnames[$i]
	done

	### trim filenames so that they are in <DATE>_<RatNumber> format
	
	len=$(echo ${#newnames[@]})
	printf "\n I found this many combinations: $len"
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
	printf "\n * * * * writing into combinations.txt file * * * * \n"
	for i in ${newnames[@]}
	do
		echo $i >> combinations.txt
		printf "\n" >> combinations.txt
	done

	#cleanup after each Rat number
	unset names
	unset newnames
	unset delete
	unset delete2
	#unset trnames
	
	sleep 3

done

