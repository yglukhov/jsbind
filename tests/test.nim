import ../jsbind
import ../jsbind/emscripten
import strutils
proc setup() =
    discard EM_ASM_INT """
    global.raiseJSException = function() {
        throw new Error("JS Exception");
    };

    global.callNimFunc = function(f) {
        f();
    };

    global.callNimFuncAfterTimeout = function(f) {
        setTimeout(f, 1);
    };
    """

setup()

type Global = ref object of JSObj

proc raiseJSException(g: Global) {.jsImport.}
proc callNimFunc(g: Global, p: proc()) {.jsImport.}
proc callNimFuncAfterTimeout(g: Global, p: proc()) {.jsImport.}

proc runTest() =
    GC_disable()

    let g = globalEmbindObject(Global, "global")
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

    GC_enable()

runTest()
