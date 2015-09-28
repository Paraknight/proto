class Shader

  create-shader = (gl, src, type) !->
    shader = gl.create-shader type
    gl.shader-source shader, src
    gl.compile-shader shader
    return shader if gl.get-shader-parameter shader, gl.COMPILE_STATUS
    console.error gl.get-shader-info-log shader

  create-program = (gl, vert-shader, frag-shader) !->
    program = gl.create-program!
    gl.attach-shader program, vert-shader
    gl.attach-shader program, frag-shader
    gl.link-program program
    return program if gl.get-program-parameter program, gl.LINK_STATUS
    console.error gl.get-program-info-log program

  (gl, @name) ->
    vert-src = require "./shaders/#name.vert.glsl"
    frag-src = require "./shaders/#name.frag.glsl"

    vert-shader = create-shader gl, vert-src, gl.VERTEX_SHADER
    frag-shader = create-shader gl, frag-src, gl.FRAGMENT_SHADER

    @program = create-program gl, vert-shader, frag-shader

    gl.use-program @program

    lines = (vert-src + frag-src).split \\n

    @attributes = {}

    for line in lines
      continue unless line.starts-with \attribute
      var-name = line.split ' ' |> -> it[it.length - 1] |> -> it.substring 0 it.length - 1
      continue if var-name of @attributes
      @attributes[var-name] = gl.get-attrib-location @program, var-name

    gl.enable-vertex-attrib-array @attributes.vertex-pos if @attributes.vertex-pos?

    @uniforms = {}

    for line in lines
      continue unless line.starts-with \uniform
      var-name = line.split ' ' |> -> it[it.length - 1] |> -> it.substring 0 it.length - 1
      continue if var-name of @uniforms
      @uniforms[var-name] = gl.get-uniform-location @program, var-name

cache = {}

export load = (gl, name) ->
  return cache[name] if name of cache
  cache[name] = new Shader gl, name
