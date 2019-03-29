#!/bin/bash
echo bcp the boost lib.
cd boost_1_66_0
sh bootstrap.sh
./bjam tools/bcp

mkdir -p bcpout
#bsc command begin
dist/bin/bcp \
format.hpp \
asio.hpp \
serialization/serialization.hpp \
thread.hpp \
bind/bind.hpp \
regex.hpp \
ref.hpp \
bind.hpp \
phoenix.hpp \
phoenix/support/detail/iterate.hpp \
core/null_deleter.hpp \
bcpout
#bcp command end
cd ..
echo bcp complate !
