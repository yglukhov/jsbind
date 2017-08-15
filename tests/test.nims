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
    #--d:release

    proc passEmcc(s: string) =
        switch("passC", s)
        switch("passL", s)

    proc passEmccS(s: string) =
        passEmcc("-s " & s)

    passEmccS "NO_EXIT_RUNTIME=1"
    passEmccS "ASSERTIONS=2"

else:
    echo "test nims not emscripten"
