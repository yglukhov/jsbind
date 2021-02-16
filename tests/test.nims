import ospaths
when defined(emscripten):
    --cpu:i386
    --cc:clang
    --os:linux

    let emcc = findExe("emcc")
    --clang.exe:emcc
    --clang.linkerexe:emcc
    --o:test.js
    --linedir:on
    --d:noSignalHandler
    #--d:release

    proc passEmcc(s: string) =
        switch("passC", s)
        switch("passL", s)

    proc passEmccS(s: string) =
        passEmcc("-s " & s)

    passEmccS "NO_EXIT_RUNTIME=1"
    passEmccS "ASSERTIONS=2"
elif defined(wasm):
    --os:linux
    --cpu:i386
    --cc:clang
    --gc:orc
    --d:release
    --nomain
    --opt:size
    --listCmd
    --stackTrace:off
    --d:noSignalHandler
    --exceptions:goto
    --app:lib

    let llTarget = "wasm32-unknown-unknown-wasm"

    switch("passC", "--target=" & llTarget)
    switch("passL", "--target=" & llTarget)

    switch("passC", "-I/usr/include") # Wouldn't compile without this :(

    switch("passC", "-flto") # Important for code size!

    # gc-sections seems to not have any effect
    var linkerOptions = "-nostdlib -Wl,--no-entry,--allow-undefined,--export-dynamic,--gc-sections,--strip-all"

    switch("clang.options.linker", linkerOptions)
    switch("clang.cpp.options.linker", linkerOptions)

else:
    echo "test nims not emscripten"
