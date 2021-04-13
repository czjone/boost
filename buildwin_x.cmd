 rem 请自行修改路径，cd到boost解压后的目录下 
echo compile windows version.... 
dir=`dirname $0`  
cd "boost_1_66_0"  
rem 编译bjam 
bootstrap.sh   
echo "build boost mswindows dev"  
bjam -j16 --with-iostreams --with-regex --with-timer --with-exception --with-chrono --with-log --with-serialization --with-signals --with-date_time --with-filesystem --with-system --with-thread --build-dir=stage --stagedir=stage/windows define=_LITTLE_ENDIAN link=static stage  
echo "Completed successfully"  
cd ..