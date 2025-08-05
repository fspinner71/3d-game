if exist ./build/ (
    rmdir /s /q build
)
mkdir build

if exist ./bin/ (
    rmdir /s /q bin
)

cd build
cmake ..
cmake --build . && move bin ..