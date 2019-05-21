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
signal.hpp \
boost/signals2/signal.hpp \
bind.hpp \
phoenix.hpp \
phoenix/support/detail/iterate.hpp \
core/null_deleter.hpp \
log/attributes.hpp \
log/common.hpp \
log/core.hpp \
log/exceptions.hpp \
log/expressions.hpp \
log/sinks.hpp \
log/support/date_time.hpp \
log/support/exception.hpp \
log/support/regex.hpp \
log/support/spirit_qi.hpp \
log/support/std_regex.hpp \
log/trivial.hpp \
bcpout
#bcp command end
cd ..
echo bcp complate !
