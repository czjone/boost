#!/bin/bash  
# 请自行修改路径，cd到boost解压后的目录下  
dir=`dirname $0`  
cd "boost_1_66_0"  
# 如果库文件已存在，直接退出  
if [ -e ./stage/mac/libboost_date_time.a ]; then  
  echo "libraries exist. no need to build."  
  exit 0  
fi  
  
: ${COMPILER:="clang++"}  
: ${IPHONE_SDKVERSION:=`xcodebuild -showsdks | grep iphoneos | egrep "[[:digit:]]+\.[[:digit:]]+" -o | tail -1`}  
: ${XCODE_ROOT:=`xcode-select -print-path`}  
: ${EXTRA_CPPFLAGS:="-DBOOST_AC_USE_PTHREADS -DBOOST_SP_USE_PTHREADS -stdlib=libc++"}  
  
echo "IPHONE_SDKVERSION: $IPHONE_SDKVERSION"  
echo "XCODE_ROOT:        $XCODE_ROOT"  
echo "COMPILER:          $COMPILER"  
  
echo "bootstrap"  
# 此脚本如果是被Xcode调用的话，会因为xcode export的某些变量导致失败，所以加了env -i。直接在命令行运行此脚本可以把env -i 去掉  
env -i bash ./bootstrap.sh  
echo "build boost iphone dev"  
./bjam -j16 --with-iostreams --with-regex --with-timer --with-exception --with-chrono --with-serialization --with-signals --with-date_time --with-filesystem --with-system --with-thread --build-dir=stage --stagedir=stage/mac toolset=darwin define=_LITTLE_ENDIAN link=static stage  
# 库文件最终放在./stage/mac/下  
  
echo "Completed successfully"  