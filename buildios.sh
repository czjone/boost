#!/bin/bash  
# 请自行修改路径，cd到boost解压后的目录下  
dir=`dirname $0`  
cd "boost_1_66_0"  
# 如果库文件已存在，直接退出  
if [ -e ./stage/ios/libboost_date_time.a ]; then  
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
  
echo "write project-config.jam"  
# 默认生存的project-config.jam是编译Mac版的，这里直接调换掉  
rm project-config.jam  
# cat >> project-config.jam <<EOF  
echo "using darwin : ${IPHONE_SDKVERSION}~iphone  ">>project-config.jam 
echo ": $XCODE_ROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/$COMPILER -arch armv7 -arch armv7s -arch arm64 $EXTRA_CPPFLAGS  ">>project-config.jam 
echo ": <striper> <root>$XCODE_ROOT/Platforms/iPhoneOS.platform/Developer  ">>project-config.jam 
echo ": <architecture>arm <target-os>iphone  ">>project-config.jam 
echo ";  ">>project-config.jam 
echo "using darwin : ${IPHONE_SDKVERSION}~iphonesim  ">>project-config.jam 
echo ": $XCODE_ROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/$COMPILER -arch i386 -arch x86_64 $EXTRA_CPPFLAGS  ">>project-config.jam 
echo ": <striper> <root>$XCODE_ROOT/Platforms/iPhoneSimulator.platform/Developer  ">>project-config.jam 
echo ": <architecture>ia64 <target-os>iphone  ">>project-config.jam 
echo ";  ">>project-config.jam 
# EOF  
# 上面的代码里，两个using darwin分别是编译真机版和模拟器版的设置。每多一种CPU架构就要再加一个-arch xxx。  
  
echo "build boost iphone dev"  
./bjam -j16 --with-iostreams --with-regex --with-timer --with-exception --with-chrono --with-serialization --with-signals --with-date_time --with-filesystem --with-system --with-thread --build-dir=iphone-build --stagedir=iphone-build/stage toolset=darwin architecture=arm target-os=iphone macosx-version=iphone-${IPHONE_SDKVERSION} define=_LITTLE_ENDIAN link=static stage  
  
echo "build boost iphone sim"  
./bjam -j16 --with-iostreams --with-regex --with-timer --with-exception --with-chrono --with-serialization --with-signals --with-date_time --with-filesystem --with-system --with-thread --build-dir=iphonesim-build --stagedir=iphonesim-build/stage --toolset=darwin-${IPHONE_SDKVERSION}~iphonesim architecture=ia64 target-os=iphone macosx-version=iphonesim-${IPHONE_SDKVERSION} link=static stage cxxflags=-miphoneos-version-min=7.0  
  
echo "lipo"  
# 把各架构下的库文件合一，以便在xcode里可以少设置些搜索路径。做得更彻底些是各个分库合成一个大库。不过除非是把静态库加入到代码仓库，否则是浪费时间了。要合成的大库话请参考https://gist.github.com/rsobik/7513324原文。  
mkdir -p stage/ios  
lipo -create iphone-build/stage/lib/libboost_iostreams.a iphonesim-build/stage/lib/libboost_iostreams.a -output stage/ios/libboost_iostreams.a  
lipo -create iphone-build/stage/lib/libboost_regex.a iphonesim-build/stage/lib/libboost_regex.a -output stage/ios/libboost_regex.a  
lipo -create iphone-build/stage/lib/libboost_timer.a iphonesim-build/stage/lib/libboost_timer.a -output stage/ios/libboost_timer.a  
lipo -create iphone-build/stage/lib/libboost_exception.a iphonesim-build/stage/lib/libboost_exception.a -output stage/ios/libboost_exception.a  
lipo -create iphone-build/stage/lib/libboost_chrono.a iphonesim-build/stage/lib/libboost_chrono.a -output stage/ios/libboost_chrono.a  
lipo -create iphone-build/stage/lib/libboost_serialization.a iphonesim-build/stage/lib/libboost_serialization.a -output stage/ios/libboost_serialization.a  
lipo -create iphone-build/stage/lib/libboost_signals.a iphonesim-build/stage/lib/libboost_signals.a -output stage/ios/libboost_signals.a  
lipo -create iphone-build/stage/lib/libboost_atomic.a iphonesim-build/stage/lib/libboost_atomic.a -output stage/ios/libboost_atomic.a  
lipo -create iphone-build/stage/lib/libboost_wserialization.a iphonesim-build/stage/lib/libboost_wserialization.a -output stage/ios/libboost_wserialization.a  
lipo -create iphone-build/stage/lib/libboost_date_time.a iphonesim-build/stage/lib/libboost_date_time.a -output stage/ios/libboost_date_time.a  
lipo -create iphone-build/stage/lib/libboost_filesystem.a iphonesim-build/stage/lib/libboost_filesystem.a -output stage/ios/libboost_filesystem.a  
lipo -create iphone-build/stage/lib/libboost_system.a iphonesim-build/stage/lib/libboost_system.a -output stage/ios/libboost_system.a  
lipo -create iphone-build/stage/lib/libboost_thread.a iphonesim-build/stage/lib/libboost_thread.a -output stage/ios/libboost_thread.a  
# 库文件最终放在./stage/lib/下  
  
echo "Completed successfully"  