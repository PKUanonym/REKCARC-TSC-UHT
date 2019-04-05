cp ../wyz/hash.cpp std.cpp
g++ std.cpp -o std -O2
for ((i=1;i<=10;++i))
do
time ./std <$i.in >$i.ans
done
