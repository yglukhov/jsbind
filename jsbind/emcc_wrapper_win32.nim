import
    os, osproc, strutils

proc findEmcc(): string =
    result = addFileExt("emcc", ScriptExt)
    if existsFile(result): return
    let path = string(getEnv("PATH"))
    for candidate in split(path, PathSep):
        let x = (if candidate[0] == '"' and candidate[^1] == '"':
                  substr(candidate, 1, candidate.len-2) else: candidate) /
               result
        if existsFile(x):
            let sf = x.splitFile()
            return sf.dir / sf.name

proc main()=
    var args = newSeq[string]()
    args.add(findEmcc())

    for i in 1 .. paramCount():
        args.add(paramStr(i).string)

    let
        process = startProcess("python", args = args, options = {poParentStreams})
        exitCode = waitForExit(process)

    if exitCode != 0:
        echo paramStr(0)," : ", args, " exitWithCode ", exitCode

    quit(exitCode)

main()