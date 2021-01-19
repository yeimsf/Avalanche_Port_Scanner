#!/bin/bash

# Avalancher Port Scanner 
# Author: Youssef Fakhry
# github: https://github.com/yeimsf
# This Is Tool #1

alarm() {
  perl -e '
    eval {
      $SIG{ALRM} = sub { die };
      alarm shift;
      system(@ARGV);
    };
    if ($@) { exit 1 }
  ' "$@";
}
helpDoc="Help :::\n----- AVALANCHE Port Scanner -----\n-u <URL> | specifies a url\n-r <S:E> | specifies port range\n-d <DEL> | specifies a delay\n-o | specifies the search mode [use this option for searching open ports only]\n\n"
URL=""
PRange1="0"
PRange2="0"
Delay=60
PortMode=0
found=0
OptionsNom=$#
Options_Str=$@
if [ "${1}"  = "-h" ]
then
	echo -e "$helpDoc"
	exit
fi
countcheck=0
if [ $OptionsNom -ne 0 ]
then
	number_of_options=$#
	Options_Array=($(echo $Options_Str | tr '\b' '\n'))
	while [ "$countcheck" -ne $number_of_options ]
	do
		bina=`expr $countcheck % 2`
		if [ "$bina" -eq 0 -a ${Options_Array[countcheck]} = '-u' ]
		then
			found=`expr $found + 1`
			URL=`expr ${Options_Array[countcheck + 1]}`
		elif [ "$bina" -eq 0 -a ${Options_Array[countcheck]} = '-r' ]
		then
			PRange1=`expr ${Options_Array[countcheck + 1]}`
			PRange2=`expr ${Options_Array[countcheck + 2]}`
		elif [ "$bina" -eq 0 -a ${Options_Array[countcheck]} = '-d' ]
		then
			delay=`expr ${Options_Array[countcheck + 1]}`
		fi
		countcheck=`expr $countcheck + 1`
	done
	ping -c1 -w1 $URL &>/dev/null
	stat=$?
	if [ $stat = 0 ]
	then
		echo "Avalanche:Scanning Ports...."
		echo "========================================================="
		if [ ${PRange1} -eq 0 -a ${PRange2} -eq 0 ]
                then
                	nc -zvw 1 $URL 1-65535 2>&1 | grep --line-buffered "succeeded!"
			echo "Scan Finished!"
                else
                        nc -zvw 1 $URL $PRange1-$PRange2 2>&1 | grep --line-buffered "succeeded!"
			echo "Scan Finished!"
                fi
	elif [ $found = 0 ]
	then
		echo -e "------ You Must Specify A URL ------ \nuse -h for help"
		exit
	elif [ "$PRange1" -lt 0 -o "$PRange2" -lt "$PRange1" -o "$PRange2" -lt 0 ]
	then
		echo -e "------ Ranges Specified Are Invalid ------ \nuse -h for help"
		exit
	elif [ "$Delay" = "0" ]
	then
		echo -e "------ Delay Time Is Invalid ------ \nuse -h for help"
		exit
	else
		echo -e "------ The URL Specified Is Invalid Check Validation Of The URL ------ \nuse -h for help"
                exit
	fi
fi

