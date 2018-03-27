#!/bin/bash  
workdir=$(pwd)
echo "编译android库"
cd android/jni
sh build.sh
cd ${workdir}
mkdir -p boost_1_66_0/stage/android/armeabi
mkdir -p boost_1_66_0/stage/android/armeabi-v7a 
mkdir -p boost_1_66_0/stage/android/x86
cp android/obj/local/armeabi/libboost.a boost_1_66_0/stage/android/armeabi/libboost.a
cp android/obj/local/armeabi-v7a/libboost.a boost_1_66_0/stage/android/armeabi-v7a/libboost.a
cp android/obj/local/x86/libboost.a boost_1_66_0/stage/android/x86/libboost.a
echo "Completed successfully"  