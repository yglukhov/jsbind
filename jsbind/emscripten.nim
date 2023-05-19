when defined(wasm) and not defined(emscripten):
  import ./wasmrt_glue
  export wasmrt_glue
elif defined(emscripten):
  import ./emscripten_api
  export emscripten_api
else:
  {.error: "emscripten module may be imported only when compiling to emscripten target".}
