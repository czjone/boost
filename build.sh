#!/bin/bash

workdir=$(pwd)
boost_ver="1_66_0"
os="ios" 			#mac,win,ios,android,linux
libTag="maclib" 	#maclib,ioslib,linuxlib,androidlib,winlib
libs="asio"    		#asio,thread,and so on!

cd ../boost_v${boost_ver}_src
boostBuildDir="boost_${boost_ver}"

echo 开始生成boost库.....

#解压boost 库
if [ ! -d ${boostBuildDir} ]; then 
	if [ "ios" == $os -o "mac" == $os -o "android" == $os -o "linux" == $os  ]; then 
		echo "解压boost v${boost_ver}..."
		tar -xvf "boost_${boost_ver}(unix).tar"
		echo "解压boost v${boost_ver} 完成!"
	fi
fi

cd $boostBuildDir
#生成编译boost要用到的工具,也是由于boost下载包编译生成的
if [ ! -f "bjam" ]; then #检查是否已生成过相应的编译工具链
	if [ "ios" == $os -o "mac" == $os -o "android" == $os -o "linux" == $os  ]; then 
		sh bootstrap.sh
	fi
fi

#设置编译参数
arg="--with-system --with-thread --with-date_time --with-regex -
-with-serialization --build-dir=iphone-build --stagedir=iphone-build/stage toolset=darwin architecture=arm target-os=iphone define=_LITTLE_ENDIAN link=static stage"
./bjam ${arg}
./bjam install --prefix=${workdir}/boostlib --with-system --with-thread --with-date_time --with-regex --with-serialization 

#使用bcp裁剪
#https://blog.csdn.net/mailsure/article/details/69950859

# #修改boost的project-config.jam生成不支持的平台版本
# if [ "ios" == $os ]; then 
	
# fi
# if [ "mac" == $os ]; then 
# 	./bjam ${arg}
# fi


#copy 头文件到目录
# cp ../${boostBuildDir}/(*.h)  test2/

echo 生成boost库成功.....