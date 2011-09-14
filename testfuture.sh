#! /bin/sh

wd=/tmp/testfuture
if test -d $wd
then
    rm -rf $wd
fi

mkdir $wd
cd $wd
echo "Testing in directory $wd"

files='timbl-6.4.1 timblserver-1.3 mbt-3.2.6 mbtserver-0.3 dimbl-0.9 ucto-0.4.7 frog-0.12.5'
for file in $files
do 
    wget http://ilk.uvt.nl/downloads/pub/software/$file.tar.gz > /dev/null 2>&1 
    if test -e $file.tar.gz
    then
	echo "downloaded $file"
	tar zxf $file.tar.gz 
    fi
done

# configure and make all
for file in $files
do 
    for dir in $file*
    do 
	if test -d $dir
	then
	    cd $dir
	    echo "configuring $file in $dir"
	    ./configure --prefix=$wd > $wd/$file.log 2>&1
	    echo "making $file in $dir"
	    make install >> $wd/$file.log 2>&1
	    cd $wd
	fi
    done
done

# poor mans test
for file in timbl timblserver mbt mbtg mbtserver dimbl ucto frog
do 
    ./bin/$file -V
done

