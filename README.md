# jsbind

Create bindings to JavaScript that work when Nim is compiled to JavaScript as well as when compiled to Asm.js (through [Emscripten](http://emscripten.org)).

Here's an example of how `XMLHttpRequest` can be defined:
```nim
import jsbind

type XMLHTTPRequest* = ref object of JSObj # Define the type. JSObj should be the root class for such types.

proc newXMLHTTPRequest*(): XMLHTTPRequest {.jsimportgWithName: "function(){return (window.XMLHttpRequest)?new XMLHttpRequest():new ActiveXObject('Microsoft.XMLHTTP')}".}

proc open*(r: XMLHTTPRequest, httpMethod, url: cstring) {.jsimport.}
proc send*(r: XMLHTTPRequest) {.jsimport.}
proc send*(r: XMLHTTPRequest, body: cstring) {.jsimport.}

proc addEventListener*(r: XMLHTTPRequest, event: cstring, listener: proc()) {.jsimport.}
proc setRequestHeader*(r: XMLHTTPRequest, header, value: cstring) {.jsimport.}

proc responseText*(r: XMLHTTPRequest): jsstring {.jsimportProp.}
proc statusText*(r: XMLHTTPRequest): jsstring {.jsimportProp.}

proc `responseType=`*(r: XMLHTTPRequest, t: cstring) {.jsimportProp.}
proc response*(r: XMLHTTPRequest): JSObj {.jsimportProp.}
```
Use the bindings as normal Nim functions. They will work in both JS and Asm.js targets.
```nim
proc sendRequest*(meth, url, body: string, headers: openarray[(string, string)], handler: Handler) =
    let oReq = newXMLHTTPRequest()
    var reqListener: proc()
    reqListener = proc () =
        jsUnref(reqListener)
        handler(($oReq.statusText,  $oReq.responseText))
    jsRef(reqListener)
    oReq.responseType = "text"
    oReq.addEventListener("load", reqListener)
    oReq.open(meth, url)
    for h in headers:
        oReq.setRequestHeader(h[0], h[1])
    if body.isNil:
        oReq.send()
    else:
        oReq.send(body)
```

# Low-level Emscripten bindings
`jsbind.emscripten` module defines the types and functions that emscripten defines along with some useful macros and pragmas such as `EM_ASM_INT`, `EM_ASM_FLOAT`, `EMSCRIPTEN_KEEPALIVE`, etc.
```nim
import jsbind.emscripten
proc foo() {.EMSCRIPTEN_KEEPALIVE.} = # now it's possible to call this function from JS
  discard EM_ASM_INT("""
  alert("hello, world!");
  """) # Use EM_ASM_* like you would do it in C

# How jsbind works
When compiling to JavaScript, `jsbind` does almost nothing, translating its pragmas to corresponding `importc`, `importcpp`, etc. Basically there is no runtime cost for such bindings. The real magic happens when compiling to Emscripten. The imported functions are wrapped to `EM_ASM_*` calls, inside which the arguments are unpacked to JavaScript types as needed, and their return values are packed back to Asm.js.

# Passing closures to imported functions
Closures are special because they have environment that can be garbage collected when no references to the closure left. Consider the example above with `sendRequest`. The `reqListener` is passed to Emscripten/JS function and no references are left after `sendRequest` returns. Here we need to explicitly protect it from collection with `jsRef`, and not forget to unprotect it when it is no longer needed with `jsUnref`, otherwise it will leak. `jsRef` and `jsUnref` do nothing when compiled to JavaScript, still its a good practice to place them where appropriate to make your bindings compatible with Asm.js.
