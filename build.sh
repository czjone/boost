sh bcpboost.sh
sh buildios.sh
sh buildmac.sh
sh buildandroid.sh
mv boost_1_66_0/stage bin
rm -rf bin/boost
cp -rf boost_1_66_0/bcpout/boost bin/boost