#!/bin/bash

directory=compressor_decompressor_temp_dir
gzipCounter=0
bzip2Counter=0
tarCounter=0
zipCounter=0

function main {	
	
	clear
	echo "========================================================="
	echo "---------------- [De]/Compressor Utility ----------------"
	echo "========================================================="
	echo -n "Do you want to [D]ecompress or [C]ompress a file?(D/c): "
	read choice

	if [[ $choice == 'D' || $choice == 'd' ]]
	then
		decompressor
		echo "----- Finished Decompressing -----" && sleep 1.5 

	elif [[ $choice == 'C' || $choice == 'c' ]]
	then
		compressor
		echo "----- Finished Compressing -----" && sleep 1.5 
	else
		echo "Error, Program Exit!"
		exit 1
	fi

	clear && echo -n "Do you want to rename extracted file?(Y/n): "
	read answer
	if [[ $answer == 'Y' ]] || [[ $answer == 'y' ]]
	then
		echo -n "Enter new name: "
		read newName
		mv $input $newName
		input=$newName
	fi

	mv * ../ && cd ../ && rm -rf $directory && clear
	
	totalCounter=$((gzipCounter+bzip2Counter+tarCounter+zipCounter))
	
	# Bash can't handle floats. You need to use bc instead
	# scale=2 -> two decimal precision. 1000000000 -> Nanosecond (10^9)
	totalTime=$(bc <<< "scale=0;($time2-$time1)/1000000000")

	# It is better to use (( ... )) when comparing numbers
	if (( $(bc <<< "$totalTime >= 60.00") ))
	then
		totalTime1=$(bc <<< "scale=2;$totalTime/60")
		totalTime2=$(bc <<< "scale=0;$totalTime/60")
		totalTime3=$(bc <<< "60*($totalTime1-$totalTime2)")
		totalTime3=${totalTime3%.*}
		TIME="${totalTime2}.${totalTime3} minutes"
	else
		TIME="${totalTime} seconds"
	fi

	echo "================================="
	echo "             SUMMARY             "
	echo "================================="
	
	if [[ $choice == 'D' || $choice == 'd' ]]
	then
		echo "Number & Time of Decompressions:"
	else
		echo "Number & Time of Compressions:"
	fi

	echo "---------------------------------"
	echo "bzip2: $bzip2Counter"
	echo "gzip:  $gzipCounter"
	echo "tar:   $tarCounter"
	echo "zip:   $zipCounter"
	echo "---------------------------------"
	
	if [[ $choice == 'D' || $choice == 'd' ]]
	then
		echo "Total decompressions: $totalCounter"
	else
		echo "Total compressions: $totalCounter"
	fi

	echo "---------------------------------"
	echo "Time spent: $TIME"
	echo "---------------------------------"
	echo "File name: $input"
	echo "================================="
	echo "         END OF PROGRAM          "
	echo "================================="

}


# they have same meaning but different syntax for defining a function
#compressor() {
function compressor {

	while [[ true ]]
	do
		clear
		echo "===================================="
		echo "-----------  FILES LIST  -----------"
		echo "===================================="
		ls -p --color | grep -v /
		#file * | grep 'gzip\|bzip\|Zip\|POSIX' | sed 's/:.*//'
		echo "===================================="
		echo "-------   ENTER [q] TO EXIT  -------"
		echo "===================================="
		echo -n "Enter name of file or [q]uit: "
		read input && clear

		#if [[ $(ls -A | grep $input) ]]
		if [[ -f $input ]]
		then
			clear && break

		elif [[ $input == 'q' || $input == 'Q' ]]
		then
			echo -e "-----  Program Exit!  -----" && sleep 1		
			clear && exit 0	

		else
			echo -e "-----  Error, File Not Found!  -----" && sleep 1 && clear
		fi
	done

	while [[ true ]]
	do
		echo -e "Compression type:\n[1] gzip  -  [2] bzip2  -  [3] tar  - [4] zip  - [5] random"
		echo -n "Enter compression type number or [q]uit: "
		read compression_type
			
		if [[ $compression_type -ge 1 && $compression_type -le 5 ]]
		then
			break

		else
			if [[ $compression_type == 'Q' || $compression_type == 'q' ]]
			then
				clear
				echo -e "-----  Program Exit!  -----" && sleep 1 && clear		
				exit 0
			else
				echo -e "\n-----  Error, Wrong Entry!  -----" && sleep 1 && clear
			fi
		fi
	done

	echo -n "Enter nubmer of times to compress or [q]uit: "
	read counter
	
	if [[ $counter == 'Q' || $counter == 'q' ]]
	then
		clear
		echo -e "-----  Program Exit!  -----" && sleep 1 && clear		
		exit 0
	
	elif [[ $counter == "" ]]
	then 
		counter=1
	fi

	if [[ -d $directory ]]
	then
		cp $input $directory/ && cd $directory/

	else
		mkdir $directory && cp $input $directory/ && cd $directory/
	fi

	name="$input"
	clear
	
	# %H -> Hour, %M -> Minute, %S -> Second, %N -> convert time to Nanoseconds
	time1=$(date +%H%M%S%N)

	#for i in $(eval echo "{1..$flag}") // this for loop works the same and the latter
	for i in $(seq 1 $counter)
	do
		echo -ne "Please, wait! Compressing /\033[A\r" && sleep 0.05
		echo -ne "Please, wait! Compressing -\033[A\r" && sleep 0.05
		echo -ne "Please, wait! Compressing \\033[A\r" && sleep 0.05
		echo -ne "Please, wait! Compressing |\033[A\r" && sleep 0.05
		if [[ $compression_type == 5 ]]
		then
			type="$(shuf -i 1-4 -n 1)"
		else
			type=$compression_type
		fi
		
		if [[ $type == 1 ]]
		then
			gzip -q $input
			input="$(ls -A | grep *.gz)"
			mv $input $name
			gzipCounter=$((gzipCounter+1))

		elif [[ $type == 2 ]]
		then
			bzip2 -q $input
			input="$(ls -A | grep *.bz2)"
			mv $input $name
			bzip2Counter=$((bzip2Counter+1))

		elif [[ $type == 3 ]]
		then
			tar cf $input.tar $input
			rm $input
			input="$(ls -A | grep *.tar)"
			mv $input $name
			tarCounter=$((tarCounter+1))

		elif [[ $type == 4 ]]
		then
			zip -q $input.zip $input
			rm $input
			input="$(ls -A | grep *.zip)"
			mv $input $name
			zipCounter=$((zipCounter+1))
		fi
		
		input=$name
	done
	
	time2=$(date +%H%M%S%N)

}


decompressor() {

	while [[ true ]]
	do
		clear
		echo "===================================="
		echo "-----------  FILES LIST  -----------"
		echo "===================================="

		#ls -p | grep -v /
		if ! [[ $(file * | grep 'gzip\|bzip\|Zip\|POSIX' | sed 's/:.*//') ]]
		then
			echo -e "\n   EMPTY, No Files to Decompress\n"
		else
			file * | grep 'gzip\|bzip\|Zip\|POSIX' | sed 's/:.*//'
		fi

		echo "===================================="
		echo "-------   ENTER [q] TO EXIT  -------"
		echo "===================================="
		echo -n "Enter file name or [q]uit: "
		read input && clear

		if [[ -f $input ]]
		then
			clear && break

		elif [[ $input == 'q' || $input == 'Q' ]]
		then
			echo -e "---------  Program Exit!  ---------" && sleep 1		
			clear && exit 0	

		else
			echo -e "-----  Error, File Not Found!  -----" && sleep 1 && clear
		fi
	done

	if [ -d $directory ]
	then
		cp $input $directory/ && cd $directory/

	else
		mkdir $directory && cp $input $directory/ && cd $directory/
	fi
	
	name="$input"
	time1=$(date +%H%M%S%N)
	
	while [[ true ]]
	do
		echo -ne "Please, wait! Decompressing /\033[A\r" && sleep 0.05
		echo -ne "Please, wait! Decompressing -\033[A\r" && sleep 0.05
		echo -ne "Please, wait! Decompressing \\033[A\r" && sleep 0.05
		echo -ne "Please, wait! Decompressing |\033[A\r" && sleep 0.05

		type=$(file $input)
		out="$(echo $type | sed 's/,.*//' | sed 's/.*: //' | sed 's/\s.*//')"

		if [[ $out == "gzip" ]]
		then
			mv $input out.gz
			input="$(gzip -lv out.gz | sed -n '2p' | sed 's/.*% //')"
			gzip -q -d out.gz
			gzipCounter=$((gzipCounter+1))

		elif [[ $out == "bzip2" ]];
		then
			mv $input out.bz2
			bzip2 -q -d out.bz2
			input=out
			bzip2Counter=$((bzip2Counter+1))


		elif [[ $out == "POSIX" ]];
		then
			mv $input out.tar
			input=$(tar -xvf out.tar)
			rm out.tar
			tarCounter=$((tarCounter+1))


		elif [[ $out == "Zip" ]];
		then
			mv $input out.zip
			input="$(unzip out.zip | sed -n '2p' | sed 's/.*: //')"
			rm out.zip
			zipCounter=$((zipCounter+1))

		else
			break
		fi
	done

	time2=$(date +%H%M%S%N)

	mv $input $name 2>/dev/null
	input=$name

}

main
