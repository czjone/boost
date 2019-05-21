#!/bin/bash  
# 请自行修改路径，cd到boost解压后的目录下 
echo compile linux version.... 
dir=`dirname $0`  
cd "boost_1_66_0"  
# 如果库文件已存在，直接退出  
# if [ -e ./stage/mac/libboost_date_time.a ]; then  
#   echo "libraries exist. no need to build."  
#   exit 0  
# fi  
echo "build boost linux dev"  
./bjam -j16 --with-iostreams --with-regex --with-timer --with-exception --with-chrono --with-log --with-serialization --with-signals --with-date_time --with-filesystem --with-system --with-thread --build-dir=stage --stagedir=stage/linux define=_LITTLE_ENDIAN link=static stage  
echo "Completed successfully"  