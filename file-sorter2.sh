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

#user-configurable part. You can input regex into the pattern strings
#be careful, script uses full paths
pattern1=("100918.*at33" "100918.*at32" "100918.*at34" "140718.*at24" "121118.*at33" "020719.*at49" "040719.*at50" "080719.*at51" "080819.*at57" "090819.*at59" "43729.*at63" "300919.*at61" "120219.*at41" "290818.*at31" "170918.*33" "120918.*34" "140519.*at41")
#to omit looping through a pattern, just put .* in it
pattern2=(".*")
pattern3=(pos)

#echo "Where are the files you want to sort?"
#read InDir

#echo "where should I copy the sorted files?"
#read OutDir

for i in ${pattern1[@]} 
do
	for k in ${pattern2[@]}	
	do	
		
		for j in ${pattern3[@]}
		do
			#double quotes so that $ symbol is interpreted as var
			#$ needs to be escaped if interpreted as end of regex pattern
			if find $1 | grep "^.*${i}.*${k}.*${pattern3}.*\$" | xargs cp -t $2 ; then
				echo "${i} copied successfully" | tee ./fslog.txt
			else
				echo "${i} NOT FOUND" | tee ./fslog.txt
			fi
		
		done
	done
done

