when not defined(emscripten):
    {.error: "emscripten module may be imported only when compiling to emscripten target".}

import macros
import minify

type
    EMSCRIPTEN_WEBGL_CONTEXT_HANDLE* = cint
    EM_BOOL* = cint
    EMSCRIPTEN_RESULT* = cint

type EmscriptenWebGLContextAttributes* = object
    alpha*: EM_BOOL
    depth*: EM_BOOL
    stencil*: EM_BOOL
    antialias*: EM_BOOL
    premultipliedAlpha*: EM_BOOL
    preserveDrawingBuffer*: EM_BOOL
    preferLowPowerToHighPerformance*: EM_BOOL
    failIfMajorPerformanceCaveat*: EM_BOOL

    majorVersion*: cint
    minorVersion*: cint

    enableExtensionsByDefault*: EM_BOOL

type EmscriptenMouseEvent* = object
    timestamp*: cdouble
    screenX*: clong
    screenY*: clong
    clientX*: clong
    clientY*: clong
    ctrlKey*: EM_BOOL
    shiftKey*: EM_BOOL
    altKey*: EM_BOOL
    metaKey*: EM_BOOL
    button*: uint16
    buttons*: uint16
    movementX*: clong
    movementY*: clong
    targetX*: clong
    targetY*: clong
    canvasX*: clong
    canvasY*: clong
    padding*: clong

type EmscriptenTouchPoint* = object
    identifier*: clong
    screenX*: clong
    screenY*: clong
    clientX*: clong
    clientY*: clong
    pageX*: clong
    pageY*: clong
    isChanged*: EM_BOOL
    onTarget*: EM_BOOL
    targetX*: clong
    targetY*: clong
    canvasX*: clong
    canvasY*: clong

type EmscriptenTouchEvent* = object
    numTouches*: cint
    ctrlKey*: EM_BOOL
    shiftKey*: EM_BOOL
    altKey*: EM_BOOL
    metaKey*: EM_BOOL
    touches*: array[32, EmscriptenTouchPoint]

type EmscriptenUiEvent* = object
    detail*: clong
    documentBodyClientWidth*: cint
    documentBodyClientHeight*: cint
    windowInnerWidth*: cint
    windowInnerHeight*: cint
    windowOuterWidth*: cint
    windowOuterHeight*: cint
    scrollTop*: cint
    scrollLeft*: cint

type EmscriptenOrientationChangeEvent* = object
    orientationIndex*: cint
    orientationAngle*: cint

type EmscriptenWheelEvent* = object
    mouse*: EmscriptenMouseEvent
    deltaX*: cdouble
    deltaY*: cdouble
    deltaZ*: cdouble
    deltaMode*: culong

type EmscriptenKeyboardEvent* = object
    key*: array[32, char]
    code*: array[32, char]
    location*: culong
    ctrlKey*: EM_BOOL
    shiftKey*: EM_BOOL
    altKey*: EM_BOOL
    metaKey*: EM_BOOL
    repeat*: EM_BOOL
    locale*: array[32, char]
    charValue*: array[32, char]
    charCode*: culong
    keyCode*: culong
    which*: culong

type EmscriptenFocusEvent* = object
    nodeName*: array[128, char]
    id*: array[128, char]

type EmscriptenFullscreenChangeEvent* = object
    isFullscreen*: EM_BOOL
    fullscreenEnabled*: EM_BOOL
    nodeName*: array[128, char]
    id*: array[128, char]
    elementWidth*: cint
    elementHeight*: cint
    screenWidth*: cint
    screenHeight*: cint

type EMSCRIPTEN_FULLSCREEN_SCALE* {.size: sizeof(cint).} = enum
    EMSCRIPTEN_FULLSCREEN_SCALE_DEFAULT = 0
    EMSCRIPTEN_FULLSCREEN_SCALE_STRETCH = 1
    EMSCRIPTEN_FULLSCREEN_SCALE_ASPECT = 2
    EMSCRIPTEN_FULLSCREEN_SCALE_CENTER = 3

type EMSCRIPTEN_FULLSCREEN_CANVAS_SCALE* {.size: sizeof(cint).} = enum
    EMSCRIPTEN_FULLSCREEN_CANVAS_SCALE_NONE = 0
    EMSCRIPTEN_FULLSCREEN_CANVAS_SCALE_STDDEF = 1
    EMSCRIPTEN_FULLSCREEN_CANVAS_SCALE_HIDEF = 2

type EMSCRIPTEN_FULLSCREEN_FILTERING* {.size: sizeof(cint).} = enum
    EMSCRIPTEN_FULLSCREEN_FILTERING_DEFAULT = 0
    EMSCRIPTEN_FULLSCREEN_FILTERING_NEAREST = 1
    EMSCRIPTEN_FULLSCREEN_FILTERING_BILINEAR = 2

type em_canvasresized_callback_func* = proc(eventType: cint, reserved, userData: pointer): EM_BOOL {.cdecl.}

type EmscriptenFullscreenStrategy* = object
    scaleMode*: EMSCRIPTEN_FULLSCREEN_SCALE
    canvasResolutionScaleMode*: EMSCRIPTEN_FULLSCREEN_CANVAS_SCALE
    filteringMode*: EMSCRIPTEN_FULLSCREEN_FILTERING
    canvasResizedCallback*: em_canvasresized_callback_func
    canvasResizedCallbackUserData*: pointer

const EMSCRIPTEN_ORIENTATION_PORTRAIT_PRIMARY*    = 1
const EMSCRIPTEN_ORIENTATION_PORTRAIT_SECONDARY*  = 2
const EMSCRIPTEN_ORIENTATION_LANDSCAPE_PRIMARY*   = 4
const EMSCRIPTEN_ORIENTATION_LANDSCAPE_SECONDARY* = 8


type em_callback_func* = proc() {.cdecl.}
type em_arg_callback_func* = proc(p: pointer) {.cdecl.}
type em_str_callback_func* = proc(s: cstring) {.cdecl.}
type em_async_wget_onload_func* = proc(a: pointer, p: pointer, sz: cint) {.cdecl.}
type em_mouse_callback_func* = proc(eventType: cint, mouseEvent: ptr EmscriptenMouseEvent, userData: pointer): EM_BOOL {.cdecl.}
type em_touch_callback_func* = proc(eventType: cint, touchEvent: ptr EmscriptenTouchEvent, userData: pointer): EM_BOOL {.cdecl.}
type em_ui_callback_func* = proc(eventType: cint, uiEvent: ptr EmscriptenUiEvent, userData: pointer): EM_BOOL {.cdecl.}
type em_orientationchange_callback_func* = proc(eventType: cint, uiEvent: ptr EmscriptenOrientationChangeEvent, userData: pointer): EM_BOOL {.cdecl.}
type em_wheel_callback_func* = proc(eventType: cint, wheelEvent: ptr EmscriptenWheelEvent, userData: pointer): EM_BOOL {.cdecl.}
type em_key_callback_func* = proc(eventType: cint, keyEvent: ptr EmscriptenKeyboardEvent, userData: pointer): EM_BOOL {.cdecl.}
type em_focus_callback_func* = proc(eventType: cint, focusEvet: ptr EmscriptenFocusEvent, userData: pointer): EM_BOOL {.cdecl.}
type em_webgl_context_callback* = proc(eventType: cint, reserved: pointer, userData: pointer): EM_BOOL {.cdecl.}
type em_fullscreenchange_callback_func* = proc(eventType: cint, fullscreenChangeEvent: ptr EmscriptenFullscreenChangeEvent, userData: pointer): EM_BOOL {.cdecl.}

{.push importc.}
proc emscripten_webgl_init_context_attributes*(attributes: ptr EmscriptenWebGLContextAttributes)
proc emscripten_webgl_create_context*(target: cstring, attributes: ptr EmscriptenWebGLContextAttributes): EMSCRIPTEN_WEBGL_CONTEXT_HANDLE
proc emscripten_webgl_make_context_current*(context: EMSCRIPTEN_WEBGL_CONTEXT_HANDLE): EMSCRIPTEN_RESULT
proc emscripten_set_main_loop*(f: em_callback_func, fps, simulate_infinite_loop: cint)
proc emscripten_cancel_main_loop*()

proc emscripten_set_mousedown_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_mouse_callback_func): EMSCRIPTEN_RESULT
proc emscripten_set_mouseup_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_mouse_callback_func): EMSCRIPTEN_RESULT
proc emscripten_set_mousemove_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_mouse_callback_func): EMSCRIPTEN_RESULT

proc emscripten_set_touchstart_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_touch_callback_func): EMSCRIPTEN_RESULT
proc emscripten_set_touchend_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_touch_callback_func): EMSCRIPTEN_RESULT
proc emscripten_set_touchmove_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_touch_callback_func): EMSCRIPTEN_RESULT
proc emscripten_set_touchcancel_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_touch_callback_func): EMSCRIPTEN_RESULT

proc emscripten_set_wheel_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_wheel_callback_func): EMSCRIPTEN_RESULT

proc emscripten_set_resize_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_ui_callback_func): EMSCRIPTEN_RESULT
proc emscripten_set_scroll_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_ui_callback_func): EMSCRIPTEN_RESULT

proc emscripten_set_orientationchange_callback_on_thread*(userData: pointer, useCapture: EM_BOOL, callback: em_orientationchange_callback_func): EMSCRIPTEN_RESULT

proc emscripten_get_mouse_status*(mouseState: ptr EmscriptenMouseEvent): EMSCRIPTEN_RESULT

proc emscripten_async_wget_data*(url: cstring, arg: pointer, onload: em_async_wget_onload_func, onerror: em_arg_callback_func)

proc emscripten_set_keypress_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_key_callback_func): EMSCRIPTEN_RESULT
proc emscripten_set_keydown_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_key_callback_func): EMSCRIPTEN_RESULT
proc emscripten_set_keyup_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_key_callback_func): EMSCRIPTEN_RESULT

proc emscripten_set_blur_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_focus_callback_func): EMSCRIPTEN_RESULT
proc emscripten_set_focus_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_focus_callback_func): EMSCRIPTEN_RESULT

proc emscripten_set_webglcontextlost_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_webgl_context_callback): EMSCRIPTEN_RESULT
proc emscripten_set_webglcontextrestored_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_webgl_context_callback): EMSCRIPTEN_RESULT
proc emscripten_is_webgl_context_lost*(target: cstring): EM_BOOL

proc emscripten_set_element_css_size*(target: cstring, width, height: cdouble): EMSCRIPTEN_RESULT
proc emscripten_get_device_pixel_ratio*(): cdouble

proc emscripten_request_fullscreen*(target: cstring, deferUntilInEventHandler: EM_BOOL): EMSCRIPTEN_RESULT
proc emscripten_request_fullscreen_strategy*(target: cstring, deferUntilInEventHandler: EM_BOOL, fullscreenStrategy: ptr EmscriptenFullscreenStrategy): EMSCRIPTEN_RESULT
proc emscripten_exit_fullscreen*(): EMSCRIPTEN_RESULT
proc emscripten_enter_soft_fullscreen*(target: cstring, fullscreenStrategy: ptr EmscriptenFullscreenStrategy): EMSCRIPTEN_RESULT
proc emscripten_exit_soft_fullscreen*(): EMSCRIPTEN_RESULT
proc emscripten_get_fullscreen_status*(fullscreenStatus: ptr EmscriptenFullscreenChangeEvent): EMSCRIPTEN_RESULT
proc emscripten_set_fullscreenchange_callback_on_thread*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_fullscreenchange_callback_func): EMSCRIPTEN_RESULT

proc emscripten_lock_orientation*(allowedOrientations: cint): EMSCRIPTEN_RESULT
{.pop.}

# backward compatibility with emcc 1.37
proc emscripten_set_mousedown_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_mouse_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_mousedown_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_mouseup_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_mouse_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_mouseup_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_mousemove_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_mouse_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_mousemove_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_touchstart_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_touch_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_touchstart_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_touchend_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_touch_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_touchend_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_touchmove_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_touch_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_touchmove_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_touchcancel_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_touch_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_touchcancel_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_wheel_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_wheel_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_wheel_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_resize_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_ui_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_resize_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_scroll_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_ui_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_scroll_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_keypress_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_key_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_keypress_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_keydown_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_key_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_keydown_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_keyup_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_key_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_keyup_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_blur_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_focus_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_blur_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_focus_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_focus_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_focus_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_webglcontextlost_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_webgl_context_callback): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_webglcontextlost_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_webglcontextrestored_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_webgl_context_callback): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_webglcontextrestored_callback_on_thread(target, userData, useCapture, callback)
proc emscripten_set_fullscreenchange_callback*(target: cstring, userData: pointer, useCapture: EM_BOOL, callback: em_fullscreenchange_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_fullscreenchange_callback_on_thread(target, userData, useCapture, callback)

proc emscripten_set_orientationchange_callback*(userData: pointer, useCapture: EM_BOOL, callback: em_orientationchange_callback_func): EMSCRIPTEN_RESULT {.inline.} =
    emscripten_set_orientationchange_callback_on_thread(userData, useCapture, callback)


macro EMSCRIPTEN_KEEPALIVE*(someProc: untyped): typed =
    result = someProc
    #[
      Ident !"exportc"
      ExprColonExpr
        Ident !"codegenDecl"
        StrLit __attribute__((used)) $# $#$#
    ]#
    result.addPragma(newIdentNode("exportc"))
    # emcc mangle cpp function names. This code fix it
    when defined(cpp):
        result.addPragma(newNimNode(nnkExprColonExpr).add(
            newIdentNode("codegenDecl"),
            newLit("__attribute__((used)) extern \"C\" $# $#$#")))
    else:
        result.addPragma(newNimNode(nnkExprColonExpr).add(
            newIdentNode("codegenDecl"),
            newLit("__attribute__((used)) $# $#$#")))

const oldEmAsm = defined(jsbindNoEmJs)

when oldEmAsm:
    macro declTypeWithHeader(h: static[string]): untyped =
        result = parseStmt("type DummyHeaderType {.importc: \"void\", header:\"" & $h & "\".} = object")

    template ensureHeaderIncluded(h: static[string]): untyped =
        block:
            declTypeWithHeader(h)
            var tht : ptr DummyHeaderType = nil

    template EM_ASM*(code: static[string]) =
        ensureHeaderIncluded("<emscripten.h>")
        {.emit: "EM_ASM(" & code & ");".}

    proc emAsmAux*(code: string, args: NimNode, resTypeName, emResType: string): NimNode =
        result = newNimNode(nnkStmtList)
        result.add(newCall(bindSym "ensureHeaderIncluded", newLit("<emscripten.h>")))

        result.add(
            newNimNode(nnkVarSection).add(
                newNimNode(nnkIdentDefs).add(
                    newNimNode(nnkPragmaExpr).add(
                        newIdentNode("emasmres"),
                        newNimNode(nnkPragma).add(
                            newIdentNode("exportc")
                        )
                    ),
                    newIdentNode(resTypeName),
                    newEmptyNode()
                )
            )
        )

        var emitStr = ""
        if args.len == 0:
            emitStr = "emasmres = EM_ASM_" & emResType & "_V({" & code & "});"
        else:
            let argsSection = newNimNode(nnkLetSection)
            for i in 0 ..< args.len:
                argsSection.add(
                    newNimNode(nnkIdentDefs).add(
                        newNimNode(nnkPragmaExpr).add(
                            newIdentNode("emasmarg" & $i),
                            newNimNode(nnkPragma).add(
                                newIdentNode("exportc")
                            )
                        ),
                        newEmptyNode(),
                        args[i]
                    )
                )
            result.add(argsSection)
            emitStr = "emasmres = EM_ASM_" & emResType & "({" & code & "}"
            for i in 0 ..< args.len:
                emitStr &= ", emasmarg" & $i
            emitStr &= ");"

        result.add(
            newNimNode(nnkPragma).add(
                newNimNode(nnkExprColonExpr).add(
                    newIdentNode("emit"),
                    newLit(emitStr)
                )
            )
        )

        result.add(newIdentNode("emasmres"))

        result = newNimNode(nnkBlockStmt).add(
            newEmptyNode(),
            result
        )

    macro EM_ASM_INT*(code: static[string], args: varargs[typed]): cint =
        result = emAsmAux(code, args, "cint", "INT")

    macro EM_ASM_DOUBLE*(code: static[string], args: varargs[typed]): cdouble =
        result = emAsmAux(code, args, "cdouble", "DOUBLE")

proc emscripten_async_wget_data*(url: cstring, onload: proc(data: pointer, sz: cint), onerror: proc()) =
    ## Helper wrapper for emscripten_async_wget_data to pass nim closures around
    type Ctx = ref object
        onload: proc(data: pointer, sz: cint)
        onerror: proc()

    var ctx: Ctx
    ctx.new()
    ctx.onload = onload
    ctx.onerror = onerror
    GC_ref(ctx)

    proc onLoadWrapper(arg: pointer, data: pointer, sz: cint) {.cdecl.} =
        let c = cast[Ctx](arg)
        GC_unref(c)
        c.onload(data, sz)

    proc onErrorWrapper(arg: pointer) {.cdecl.} =
        let c = cast[Ctx](arg)
        GC_unref(c)
        c.onerror()

    emscripten_async_wget_data(url, cast[pointer](ctx), onLoadWrapper, onErrorWrapper)

proc skipStmtList(n: NimNode): NimNode =
    result = n
    while result.kind == nnkStmtList and result.len == 1:
        result = result[0]

var procNameCounter {.compileTime.} = 0

proc concatStrings(args: varargs[string]): string =
    for a in args: result &= a

iterator arguments(formalParams: NimNode): tuple[idx: int, name, typ, default: NimNode] =
  formalParams.expectKind(nnkFormalParams)
  var iParam = 0
  for i in 1 ..< formalParams.len:
    let pp = formalParams[i]
    for j in 0 .. pp.len - 3:
      yield (iParam, pp[j], copyNimTree(pp[^2]), pp[^1])
      inc iParam

proc cTypeName(T: typedesc): string =
    when T is cstring:
        "char*"
    elif T is cint:
        "int"
    elif T is cfloat:
        "float"
    elif T is cdouble:
        "double"
    elif T is pointer:
        "void*"
    elif T is ptr:
        "void*"
    else:
        {.error: "Ensupported type: " & $T.}

proc escapeJs(s: string, escapeDollarWith = "$"): string {.compileTime.} =
    result = ""
    for c in s:
        case c
        of '\a': result.add "\\a" # \x07
        of '\b': result.add "\\b" # \x08
        of '\t': result.add "\\t" # \x09
        of '\L': result.add "\\n" # \x0A
        of '\r': result.add "\\r" # \x0A
        of '\v': result.add "\\v" # \x0B
        of '\f': result.add "\\f" # \x0C
        of '\e': result.add "\\e" # \x1B
        of '\\': result.add("\\\\")
        of '\'': result.add("\\'")
        of '\"': result.add("\\\"")
        of '$': result.add(escapeDollarWith)
        else: result.add(c)

proc declareEmJsExporter(cName, paramStr, jsImpl: static[string]) =
    const code = jsImpl.minifyJs().escapeJs()
    proc theExporter() {.importc: cName, codegenDecl: """__attribute__((used, visibility("default"))) const char* """ & cName & "() { return \"(" & paramStr & ")<::>{" & code & "}\"; }\n".}
    theExporter()

macro EM_JS*(p: untyped): untyped =
    p.expectKind(nnkProcDef)
    let jsImpl = p.body.skipStmtList()
    jsImpl.expectKind(nnkStrLit)
    var procName: string
    when not defined(release):
        procName = $p.name & "_"
    else:
        procName = "jsbind"

    procName &= $procNameCounter
    inc procNameCounter

    let importedProc = copyNimTree(p)

    importedProc.body = newEmptyNode()
    importedProc.addPragma(newTree(nnkExprColonExpr, ident"importc", newLit(procName)))
    importedProc.addPragma(ident"cdecl")

    result = newNimNode(nnkStmtList)
    result.add(importedProc)

    var paramStr = newCall(bindSym"concatStrings")

    let exportedProcCIdent = newLit("__em_js__" & procName)
    # let exportedProcIdent = ident("em_js_" & procName)
    for (i, name, typ, _) in arguments(importedProc.params):
        if i != 0:
            paramStr.add(newLit(","))
        paramStr.add(newCall(bindSym"cTypeName", typ))
        paramStr.add(newLit(" " & $name))

    let declareEmJsExporter = bindSym("declareEmJsExporter")

    result.add quote do:
        `declareEmJsExporter`(`exportedProcCIdent`, `paramStr`, `jsImpl`)

when not oldEmAsm:
    import strutils
    proc emAsmAux*(code: string, args: NimNode, resTypeName: string): NimNode =
        let prcName = genSym(nskProc, "emasm")
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

        let theProc = newProc(prcName, nimProcArgs, newLit(code), nnkProcDef)
        result = newNimNode(nnkStmtListExpr)
        result.add(newCall(bindSym"EM_JS", theProc))
        result.add(theCall)

    macro EM_ASM_INT*(code: static[string], args: varargs[typed]): cint =
        result = emAsmAux(code, args, "cint")

    macro EM_ASM_DOUBLE*(code: static[string], args: varargs[typed]): cdouble =
        result = emAsmAux(code, args, "cdouble")

    macro EM_ASM*(code: static[string], args: varargs[typed]) =
        result = emAsmAux(code, args, "void")

#[
dumpTree:
    block:
        ensureHeaderIncluded("<emscripten.h>")
        var emasmres {.exportc.}: cint
        var arg1 = 0
        var arg2 = 0
        let
            emasmarg1 {.exportc.} = arg1
            emasmarg2 {.exportc.} = arg2

        {.emit: "emasmres = EM_ASM_INT({" & "asdf" & "}, emasmarg1);".}
        emasmres
]#