#!/bin/bash

\rm -f *.diff
\rm -f *.tmp
\rm -f test.out*

if [ "$timbl_bin" == "" ];
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
export comm="$VG $timbl_bin/timbl"

./basictests
./optionstest
./metrictests
./testbugs
./test_ttt


for file in apitest testexemplar testencoding testnormalisation testnumerics \
    	    testbeaming testweighting testdecay testindirect testsimilarity \
	    testloo testcv testexpand testib2 testbinary testsparse testocc
do ./testone.sh $file
done

echo running some long tests!

for file in [ testlong testclones servertests httpservertest]

do ./testone.sh $file
done
