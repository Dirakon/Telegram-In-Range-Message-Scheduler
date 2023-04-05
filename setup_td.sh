# Setting up to use https://github.com/Bannerets/tdl

mkdir td
cd td

git clone git@github.com:tdlib/td.git .

# Building (https://github.com/tdlib/td#building)
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build .
