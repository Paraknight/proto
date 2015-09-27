require! {
  'gl-matrix': { mat4 }

  'core/entity.ls': { Entity, EntityTicker, EntityRenderer, Synchronizable, Persistent }
  'gfx/gl.ls': { GLMatrices }
  'gfx/shader.ls'
}

export class Planet extends Entity implements Synchronizable, Persistent
  (uid, parent, pos) ->
    super uid, parent
    @pos = pos or x: 0 y: 0 z: 0

    @renderer = new PlanetRenderer @


class PlanetRenderer extends EntityRenderer
  init: (gl) !->
    icosphere = require 'core/meshes.ls' .gen-icosphere 4

    @vertex-buffer = gl.create-buffer!
    gl.bind-buffer gl.ARRAY_BUFFER, @vertex-buffer
    gl.buffer-data gl.ARRAY_BUFFER, (new Float32Array icosphere.vertices), gl.STATIC_DRAW
    @vertex-buffer.size  = 3
    @vertex-buffer.count = icosphere.vertices.length

    @index-buffer = gl.create-buffer!
    gl.bind-buffer gl.ELEMENT_ARRAY_BUFFER, @index-buffer
    gl.buffer-data gl.ELEMENT_ARRAY_BUFFER, (new Uint16Array icosphere.indices), gl.STATIC_DRAW
    @index-buffer.size  = 3
    @index-buffer.count = icosphere.indices.length

    @shader = shader.load gl, \planet

    super ...

  render: (gl, matrices) !->
    gl.use-program @shader.program
    matrices.set-mode GLMatrices.modes.MODEL
    matrices.translate [ 0.0, 0.0, 0.0 ]
    gl.bind-buffer gl.ARRAY_BUFFER, @vertex-buffer
    gl.bind-buffer gl.ELEMENT_ARRAY_BUFFER, @index-buffer
    gl.vertex-attrib-pointer @shader.attributes.vertex-pos, 3, gl.FLOAT, false, 0, 0
    gl.uniform-matrix4fv @shader.uniforms.model-matrix, gl.FALSE, matrices.get-matrix GLMatrices.modes.MODEL
    gl.uniform-matrix4fv @shader.uniforms.view-matrix,  gl.FALSE, matrices.get-matrix GLMatrices.modes.VIEW
    gl.uniform-matrix4fv @shader.uniforms.proj-matrix,  gl.FALSE, matrices.get-matrix GLMatrices.modes.PROJECTION
    gl.draw-elements gl.TRIANGLES, @index-buffer.count, gl.UNSIGNED_SHORT, 0

    super ...
