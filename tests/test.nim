import ../jsbind

when defined(emscripten):
    import ../jsbind/emscripten
else:
    import ../jsbind/wasmrt_glue

import strutils
proc setup() =
    discard EM_ASM_INT """
    var g = ((typeof window) === 'undefined') ? global : window;
    g.raiseJSException = function() {
        throw new Error("JS Exception");
    };

    g.callNimFunc = function(f) {
        f();
    };

    g.getSomeString = function() {
        return "hello";
    };

    g.callNimFuncAfterTimeout = function(f) {
        setTimeout(f, 1);
    };

    g.consoleLog = function(f) {
        console.log(f);
    };
    """

setup()

type Global = ref object of JSObj

proc raiseJSException(g: Global) {.jsImport.}
proc callNimFunc(g: Global, p: proc()) {.jsImport.}
proc callNimFuncAfterTimeout(g: Global, p: proc()) {.jsImport.}
proc getString(): string {.jsImportgWithName: "getSomeString".}
proc consoleLog(s: jsstring) {.jsImportgWithName:"(function(a){console.log(a)})".}

proc runTest() =
    when not defined(gcDestructors):
        GC_disable()

    let g = globalEmbindObject(Global, "global")

    doAssert(getString() == "hello")

    block: # We should catch exceptions coming from JS
        var msg = ""
        try:
            g.raiseJSException()
        except:
            msg = getCurrentExceptionMsg()
        doAssert(msg.startsWith("JS Exception"))

    block: # We should catch exceptions coming from nim called by JS
        var msg = ""
        try:
            g.callNimFunc() do():
                raise newException(Exception, "Nim exception")
        except:
            msg = getCurrentExceptionMsg()
        doAssert(msg == "Nim exception")

    block:
        var msg = ""
        try:
            g.callNimFuncAfterTimeout() do():
                raise newException(Exception, "Nim exception")
        except:
            msg = getCurrentExceptionMsg()

    onUnhandledException = proc(msg: string) {.nimcall.} =
        if not msg.endsWith("unhandled exception: Nim exception [Exception]\l"):
            echo "Unexpected msg: ", msg
            doAssert(false)
        onUnhandledException = nil

    consoleLog("Test complete!")

    when not defined(gcDestructors):
        GC_enable()

runTest()
