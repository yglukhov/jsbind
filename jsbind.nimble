# Package
version       = "0.1.1"
author        = "Yuriy Glukhov"
description   = "Bind to JavaScript and Emscripten environments"
license       = "MIT"

requires "https://github.com/yglukhov/wasmrt"

task tests, "Run tests":
    exec "nim c -d:emscripten tests/test.nim"
    exec "node test.js"

task wasmrt_test, "Run wasmrt tests":
    exec "nim c -d:wasm -o:test.wasm -d:release -d:danger tests/test.nim"
    exec "node $(nimble path wasmrt)/tests/runwasm.js ./test.wasm"
