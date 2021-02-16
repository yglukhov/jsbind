import wasmrt, macros, strutils

template EMSCRIPTEN_KEEPALIVE*(p: untyped) = exportwasm(p)
template EM_JS*(s: string, p: untyped) = importwasm(s, p)

var counter {.compileTime.} = 0

proc emAsmAux*(code: string, args: NimNode, resTypeName: string): NimNode =
    let prcName = ident("emasm" & $counter) #genSym(nskProc, "emasm" & $counter)
    inc counter
    var code = code
    var nimProcArgs: seq[NimNode]
    let theCall = newCall(prcName)
    nimProcArgs.add ident(resTypeName)
    var i = 0
    for a in args:
        let argTyp = newCall(ident"typeof", a)
        nimProcArgs.add(newIdentDefs(ident("a" & $i), argTyp))
        code = code.replace("$" & $i, "a" & $i)
        theCall.add(a)
        inc i

    let theProc = newProc(prcName, nimProcArgs, newEmptyNode(), nnkProcDef)
    result = newNimNode(nnkStmtListExpr)
    result.add(newCall(bindSym"importwasm", newLit(code), theProc))
    result.add(theCall)

macro EM_ASM_INT*(code: static[string], args: varargs[typed]): cint =
    result = emAsmAux(code, args, "cint")

macro EM_ASM_DOUBLE*(code: static[string], args: varargs[typed]): cdouble =
    result = emAsmAux(code, args, "cdouble")

macro EM_ASM*(code: static[string], args: varargs[typed]) =
    result = emAsmAux(code, args, "void")
