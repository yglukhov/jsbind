# Package
version       = "0.1.1"
author        = "Yuriy Glukhov"
description   = "Bind to JavaScript and Emscripten environments"
license       = "MIT"

when defined(windows):
    bin           = @["jsbind/emcc_wrapper_win32"]

task tests, "Run tests":
    exec "nim c -d:emscripten tests/test.nim"
    exec "node test.js"
