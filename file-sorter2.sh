#!/bin/bash

#Script which looks for specific files using regex and the copies them to a new dir.
#specify directory with files to copy (input directory) as arg 1
#specify directory where files should be copied (output directory) as arg 1
#specify date of recording under pattern1
#specify rat number in pattern1 or in pattern2 (beware, can be both Rat and rat)
#specify file ext under pattern3
#read fslog.txt to see which filenames were not found.
#by Adam Hanzlik

printf "\n You have specified the following input directory: \n $1 \n"
printf "\n You have specified the following output directory: \n $2 \n \n"

declare -a pattern1
declare -a pattern2
declare -a pattern3

#user-configurable part. You can input regex into the pattern strings
#be careful, script uses full paths

#use for ctrl rats
#pattern1=("140518.*at19" "270418.*at19" "120718.*at21" "2830518.*at21" "2930518.*at21" "2530518.*at22" "170518.*at23" "180518.*at23" "100718.*at29"
#"140718.*at29" "051118.*at36" "081118.*at36" "250918.*at36" "291018.*at36" "311018.*at36" "240519.*at48" "050819.*at52" "220719.*at52" "120919.*at66")

#use for qnp rats
'pattern1=("180718.*at24" "290818.*at31" "310818.*at31" "100918.*at32" "031018.*at33" "100918.*at33" "120918.*at33" "121118.*at33" "170918.*at33" "100918.*at34" "120918.*at34" "080219.*at41" "080619.*at41" "120219.*at41"
"140519.*at41" "2510119.*at41" "290719.*at43" "090519.*at48" "020719.*at49" "040719.*at50" "080719.*at51" "080819.*at57" "090819.*at59" "300919.*at61"
"210919.*at63"


#to omit looping through a pattern, just put .* in it
pattern2=(".*")
pattern3=("pos")

for i in ${pattern1[@]} 
do
#	for k in ${pattern2[@]}	
#	do	
		
		for j in ${pattern3[@]}
		do
			#double quotes so that $ symbol is interpreted as var
			#$ needs to be escaped if interpreted as end of regex pattern
			if find $1 | grep "^.*${i}.*${j}\$" | xargs cp -t $2; then
				echo "${i}"."${j}  copied successfully" | tee -a ./fslog.txt
			else
				echo "${i} NOT FOUND" | tee -a ./fslog.txt
			fi			
					
#		done
	done
done

unset pattern1
