require! {
  'gl-matrix': { mat4 }

  'core/entity.ls': { Entity, EntityTicker, EntityRenderer, Synchronizable, Persistent }
  'gfx/gl.ls': { GLMatrices }
  'gfx/shader.ls'
}

export class Square extends Entity implements Synchronizable, Persistent
  (uid, parent, pos) ->
    super uid, parent
    @pos = pos or x: 0 y: 0 z: 0

    @renderer = new SquareRenderer @


class SquareRenderer extends EntityRenderer
  init: (gl) !->
    @vbo = gl.create-buffer!
    gl.bind-buffer gl.ARRAY_BUFFER, @vbo
    vertices = [
      1.0,   1.0,  0.0,
      -1.0,  1.0,  0.0,
      1.0,  -1.0,  0.0,
      -1.0, -1.0,  0.0
    ]
    gl.buffer-data gl.ARRAY_BUFFER, (new Float32Array vertices), gl.STATIC_DRAW
    @vbo.size = 3
    @vbo.count = 4

    @shader = shader.load gl, \test

    super ...

  render: (gl, matrices) !->
    gl.use-program @shader.program
    matrices.set-mode GLMatrices.modes.MODEL
    matrices.translate [ 0.0, 0.0, 0.0 ]
    gl.bind-buffer gl.ARRAY_BUFFER, @vbo
    gl.vertex-attrib-pointer @shader.attributes.vertex-pos, 3, gl.FLOAT, false, 0, 0
    gl.uniform-matrix4fv @shader.uniforms.model-matrix, gl.FALSE, matrices.get-matrix GLMatrices.modes.MODEL
    gl.uniform-matrix4fv @shader.uniforms.view-matrix,  gl.FALSE, matrices.get-matrix GLMatrices.modes.VIEW
    gl.uniform-matrix4fv @shader.uniforms.proj-matrix,  gl.FALSE, matrices.get-matrix GLMatrices.modes.PROJECTION
    gl.draw-arrays gl.TRIANGLE_STRIP, 0, @vbo.count

    super ...
