#!/bin/bash
# a script to move graphs of experimental sessions to corresponding folders
# !!! put in dir with graph images !!!

list=("A1" "A2" "Acontr" "A" "B1" "B2" "B")

for i in ${list[@]}
do

	mkdir ${i}
	ls | grep "^.*${i}.*png\$" | xargs -i mv {} ./${i} 

done
