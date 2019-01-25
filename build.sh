sh bcpboost.sh
# sh buildios.sh # build ios
# sh buildmac.sh  #build mac
# sh buildandroid.sh #build android
sh buildlinux.sh #build linux
mv boost_1_66_0/stage bin
rm -rf bin/boost
cp -rf boost_1_66_0/bcpout/boost bin/boost