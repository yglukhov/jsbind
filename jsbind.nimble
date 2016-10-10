# Package
version       = "0.1"
author        = "Yuriy Glukhov"
description   = "Bind to JavaScript and Emscripten environments"
license       = "MIT"

when defined(windows):
    bin           = @["jsbind/emcc_wrapper_win32"]
