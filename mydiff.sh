#! /bin/sh

lh=`hostname`
if test "$lh" = "atalanta"
then
  lh=localhost
else
  lh="$lh|localhost"
fi

if test -e $1
then
  if test -e $2
  then
      diff -w $1 $2 | grep -v "201[012]" |grep -v "\-\-\-" | grep -v "[0-9]\+[ac][0-9]\+" | grep -v "took [0-9]* seconds" | grep -v "Seconds taken:" | grep -v "based on" |grep -v $lh > md.tmp 2>& 1
      exit `wc -c < md.tmp`
  else
      echo
      echo "$2 not found"
      cat $1 > md.tmp
  fi
else
    echo
    echo "$1 not found"
fi
exit 1
