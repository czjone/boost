#!/bin/bash
echo bcp the boost lib.
cd boost_1_66_0
sh bootstrap.sh
./bjam tools/bcp

mkdir -p bcpout
#bsc command begin
dist/bin/bcp \
asio.hpp \
serialization/serialization.hpp \
thread.hpp \
bind/bind.hpp \
regex.hpp \
ref.hpp \
bind.hpp \
log/core.hpp \
log/common.hpp \
log/attributes.hpp \
log/core/record.hpp \
log/utility/setup/common_attributes.hpp \
log/expressions.hpp \
log/sinks/text_ostream_backend.hpp \
log/support/date_time.hpp \
log/utility/setup/file.hpp \
log/expressions.hpp \
phoenix.hpp \
phoenix/support/detail/iterate.hpp \
core/null_deleter.hpp \
bcpout
#bcp command end
cd ..
echo bcp complate !
