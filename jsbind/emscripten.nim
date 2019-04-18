when not defined(emscripten):
    {.error: "emscripten module may be imported only when compiling to emscripten target".}

import macros

type
    EMSCRIPTEN_WEBGL_CONTEXT_HANDLE* = cint
    EM_BOOL* = cint
    EMSCRIPTEN_RESULT* = cint

macro declTypeWithHeader(h: static[string]): untyped =
    result = parseStmt("type DummyHeaderType {.importc: \"void\", header:\"" & $h & "\".} = object")

template ensureHeaderIncluded(h: static[string]): untyped =
    block:
        declTypeWithHeader(h)
        var tht : ptr DummyHeaderType = nil

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

type em_callback_func* = proc() {.cdecl.}
type em_arg_callback_func* = proc(p: pointer) {.cdecl.}
type em_str_callback_func* = proc(s: cstring) {.cdecl.}
type em_async_wget_onload_func* = proc(a: pointer, p: pointer, sz: cint) {.cdecl.}
type em_mouse_callback_func* = proc(eventType: cint, mouseEvent: ptr EmscriptenMouseEvent, userData: pointer): EM_BOOL {.cdecl.}
type em_touch_callback_func* = proc(eventType: cint, touchEvent: ptr EmscriptenTouchEvent, userData: pointer): EM_BOOL {.cdecl.}
type em_ui_callback_func* = proc (eventType: cint, uiEvent: ptr EmscriptenUiEvent, userData: pointer): EM_BOOL {.cdecl.}
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

template EM_ASM*(code: static[string]) =
    ensureHeaderIncluded("<emscripten.h>")
    {.emit: "EM_ASM(" & code & ");".}

proc emAsmAux*(code: string, args: NimNode, resTypeName, emResType: string): NimNode =
    #echo "CODE: ", code

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