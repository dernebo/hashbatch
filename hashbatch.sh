#!/bin/bash

hashcat=/usr/bin/hashcat
base=/home/fredrikdernebo/src/hashbatch
watch=$base/work/watch
dir1=$base/work/1
dir2=$base/work/2
dir3=$base/work/3
done=$base/work/done
success=$base/success
failed=$base/failed
cracked=$base/cracked.txt

function wait {
#clear
#tree
#read -p "Press any key to continue... " -n1 -s
sleep 2
}

function watchdir {
tree
echo "Looking for files in $watch"
wait
if [ "$(ls -A $watch/*.hccapx)" ]; then
	for cap in `ls -1 $watch/*.hccapx`
        	do
                	mv $cap $dir1
			clear
			tree $work
			echo "Moved file $cap to dir1 ($dir1)"
			wait
        	done
	else
		echo "$watch is Empty"
		wait
fi

}

function work1 {
echo "Looking for files in $dir1"
if [ "$(ls -A $dir1/*.hccapx)" ]; then
        for cap in `ls -1 $dir1/*.hccapx`
                do
			$hashcat -m 2500 $cap $dir1/wordlist --restore-file-path=$dir1/$(basename $cap).restore --outfile=$cracked
                        mv $cap $dir2
                        echo "Moved file $cap to dir2 ($dir2)"
                done
        else
                echo "$dir1 is Empty"
		wait
fi
}
function work2 {
echo "Looking for files in $dir2"
if [ "$(ls -A $dir2/*.hccapx)" ]; then
        for cap in `ls -1 $dir2/*.hccapx`
                do
			$hashcat -m 2500 $cap $dir2/wordlist --restore-file-path=$dir2/$(basename $cap).restore --outfile=$cracked
                        mv $cap $dir3
                        echo "Moved file $cap to dir3 ($dir3)"
                done
        else
                echo "$dir2 is Empty"
		wait
fi
}

function work3 {
echo "Looking for files in $dir3"
if [ "$(ls -A $dir3/*.hccapx)" ]; then
        for cap in `ls -1 $dir3/*.hccapx`
                do
			$hashcat -m 2500 $cap $dir3/wordlist --restore-file-path=$dir3/$(basename $cap).restore --outfile=$cracked
                        mv $cap $done
                        echo "Moved file $cap to dir2 ($dir2)"
                done
        else
                echo "$dir1 is Empty"
		wait
fi
}

function result {
	echo Result
}



##### Main
clear
wait
watchdir
wait
work1
wait
work2
wait
work3
wait
result
wait
echo "Cracked:"
cat $cracked

