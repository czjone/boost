@echo compile boost for windows.
cd boost_1_66_0
bjam.exe -j16 --with-iostreams --with-regex --with-timer --with-exception --with-chrono --with-log --with-serialization --with-signals --with-date_time --with-filesystem --with-system --with-thread --build-dir=stage --stagedir=stage/windows/shared define=_LITTLE_ENDIAN link=shared stage  
echo "Completed successfully"
cd ..  
@echo compile complate !