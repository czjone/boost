#!/bin/bash

workdir=$(pwd)
boost_ver="1_66_0"
os="ios" 			#mac,win,ios,android,linux
libTag="maclib" 	#maclib,ioslib,linuxlib,androidlib,winlib
libs="asio"    		#asio,thread,and so on!

cd boost_${boost_ver}
boostBuildDir="../boostOut"

echo 开始生成boost库.....
#检查生成目录是否存在
if [ ! -d "${boostBuildDir}" ]; then
	mkdir -p ${boostBuildDir};
fi

#解压boost 库
# if [ ! -d ${boostBuildDir} ]; then 
# 	if [ "ios" == $os -o "mac" == $os -o "android" == $os -o "linux" == $os  ]; then 
# 		echo "解压boost v${boost_ver}..."
# 		tar -xvf "boost_${boost_ver}(unix).tar"
# 		echo "解压boost v${boost_ver} 完成!"
# 	fi
# fi

#生成编译boost要用到的工具,也是由于boost下载包编译生成的
if [ ! -f "bjam" ]; then #检查是否已生成过相应的编译工具链
	if [ "ios" == $os -o "mac" == $os -o "android" == $os -o "linux" == $os  ]; then 
		sh bootstrap.sh
	fi
fi

#生成bcp裁剪工具
if [ ! -f "bcp" ]; then
	#https://blog.csdn.net/mailsure/article/details/69950859
	./bjam tools/bcp
	cp dist/bin/bcp bcp #复制到boost目录
fi

#ios 要修改编译设置
if [ "ios" == $os ]; then
	: ${COMPILER:="clang++"}
	: ${IPHONE_SDKVERSION:=`xcodebuild -showsdks | grep iphoneos | egrep "[[:digit:]]+\.[[:digit:]]+" -o | tail -1`}
	: ${XCODE_ROOT:=`xcode-select -print-path`}
	: ${EXTRA_CPPFLAGS:="-DBOOST_AC_USE_PTHREADS -DBOOST_SP_USE_PTHREADS -stdlib=libc++"}
	rm "project-config.jam"
    echo "using darwin : ${IPHONE_SDKVERSION}~iphone">>project-config.jam
	echo ": $XCODE_ROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/$COMPILER -arch armv7 -arch arm64 $EXTRA_CPPFLAGS">>project-config.jam
	echo ": <striper> <root>$XCODE_ROOT/Platforms/iPhoneOS.platform/Developer">>project-config.jam
	echo ": <architecture>arm <target-os>iphone">>project-config.jam
	echo ";">>project-config.jam
	echo "using darwin : ${IPHONE_SDKVERSION}~iphonesim">>project-config.jam
	echo ": $XCODE_ROOT/Toolchains/XcodeDefault.xctoolchain/usr/bin/$COMPILER -arch i386 -arch x86_64 $EXTRA_CPPFLAGS">>project-config.jam
	echo ": <striper> <root>$XCODE_ROOT/Platforms/iPhoneSimulator.platform/Developer">>project-config.jam
	echo ": <architecture>ia64 <target-os>iphone">>project-config.jam
	echo ";">>project-config.jam
fi

#bcp裁剪
# smallBoost="smallBoost"
# if [ ! -d "${smallBoost}" ]; then
# 	mkdir -p "${smallBoost}"
# fi
# ./bcp boost/asio.hpp "${smallBoost}" #只包含了asio
# mv boost rawboost
# mv "${smallBoost}" boost

#二进制输出目录
outBinDir="${boostBuildDir}/bin/$os"
if [ ! -d "${outBinDir}" ]; then
	mkdir -p "${outBinDir}"
fi

#编译并安装到目录
if [ "ios" == $os -o "mac" == $os -o "android" == $os -o "linux" == $os  ]; then 
	#./bjam -j16 --with-date_time --with-filesystem --with-system --with-thread --build-dir=iphone-build --stagedir=iphone-build/stage toolset=darwin architecture=arm target-os=iphone macosx-version=iphone-${IPHONE_SDKVERSION} define=_LITTLE_ENDIAN link=static stage
	# ./bjam --with-date_time --with-filesystem --with-system --with-thread --build-dir=iphonesim-build --stagedir=iphonesim-build/stage --toolset=darwin-${IPHONE_SDKVERSION}~iphonesim architecture=ia64 target-os=iphone macosx-version=iphonesim-${IPHONE_SDKVERSION} link=static stage
	#./bjam install --prefix=${outBinDir}

	./bjam link=static threading=multi variant=release address-model=$bitlevel toolset=darwin runtime-link=static
fi

rm -rf boost
mv rawboost boost

echo 生成boost库成功.....