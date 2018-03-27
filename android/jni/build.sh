#/bin/bash
NDK_ROOT=/Users/solyess/Documents/soft/android-ndk-r9d
echo "-----------------------------------------------------------------------------------"
echo ">>>>>>>>>>>>>>>>>>>>start build boost static lib. compile by ndk-build<<<<<<<<<"
# echo "clean project..."
# $NDK_ROOT/ndk-build clean
# echo "clean project complate."
echo "build project dylib"
$NDK_ROOT/ndk-build #COCOS2D_DEBUG=1 ##DUMP_APP_ABI=1
echo "build project dylib complate."
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>end build  build boost static lib.<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
echo "-----------------------------------------------------------------------------------"
