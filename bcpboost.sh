#!/bin/bash
echo bcp the boost lib.
cd boost_1_66_0
sh bootstrap.sh
./bjam tools/bcp
mkdir -p bcpout
dist/bin/bcp asio.hpp serialization/serialization.hpp bind/bind.hpp bcpout
cd ..
echo bcp complate !