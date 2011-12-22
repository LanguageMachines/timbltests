#! /bin/sh

wd=/tmp/testdownloads
if test -d $wd
then
    rm -rf $wd
fi

mkdir $wd
cd $wd
echo "Testing in directory $wd"

files='timbl timblserver mbt mbtserver dimbl libfolia ucto frog'
for file in $files
do 
    wget http://ilk.uvt.nl/downloads/pub/software/$file-latest.tar.gz > /dev/null 2>&1 
    if test -e $file-latest.tar.gz
    then
	echo "downloaded $file"
	tar zxf $file-latest.tar.gz 
    fi
done

# configure and make all
for file in $files
do 
    for dir in $file-*
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
for file in $files
do 
    for dir in $file-*
    do 
	if test -d $dir
	then
	    ./bin/$file -V
	fi
    done
done

