#!/bin/bash
OK="\033[1;32m OK  \033[0m"
FAIL="\033[1;31m  FAILED  \033[0m"

if test "$timbl_bin" = "";
then
  timbl_bin=/home/sloot/usr/local/bin
  if [ ! -d $timbl_bin ];
  then
     timbl_bin=/exp/sloot/usr/local/bin
     if [ ! -d $timbl_bin ];
     then
       echo "cannot find timbl executables "
       exit
     fi
  fi
fi

export timbl_bin=$timbl_bin # for the clients!

if test "$comm" = "";
then export comm="$VG $timbl_bin/timbl";
fi

for file in $1
do if test -x $file
   then
   	\rm -f $file.diff
	\rm -f $file.tmp
	\rm -f test*.out*
   	echo -n "testing  $file "
	./$file > $file.tmp 2>&1
	./mydiff.sh $file.tmp $file.ok
	if [ $? -ne 0 ];
	then echo -e $FAIL;
	cp md.tmp $file.diff;
	echo "differences logged in $file.diff";
	else echo -e $OK
	fi
   else
       echo "testfile '$1' not found"
   fi
done
