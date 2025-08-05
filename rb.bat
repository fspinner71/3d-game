if not exist ./build/ (
    ./fullbuild.bat
    exit
)

if exist ./bin/ (
    rmdir /s /q bin
)

cd build
cmake --build . && move bin ..