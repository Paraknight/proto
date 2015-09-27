require! {
  'gl-matrix': { mat4, vec3 }

  'core/entity.ls': { Entity }
  'gfx/gl.ls': { GLMatrices }
}

class Camera extends Entity
  init-matrices: (gl, matrices) ->
  update-matrices: (gl, matrices) ->

export class PerspectiveCamera extends Camera

  (@fov, @near, @far) ->
    super!
    @pos    = [ 0, 0, 0 ]
    @_yaw   = 0
    @_pitch = 0
    @_roll  = 0

  _update-transform: !->
    mat4.identity  @transform
    mat4.translate @transform, @transform, @pos
    mat4.rotate-y  @transform, @transform, @yaw
    mat4.rotate-x  @transform, @transform, @pitch
    mat4.rotate-z  @transform, @transform, @roll

  yaw:~
    -> @_yaw
    (yaw) ->
      @_yaw = yaw
      @_update-transform!

  pitch:~
    -> @_pitch
    (pitch) ->
      @_pitch = pitch
      @_update-transform!

  roll:~
    -> @_roll
    (roll) ->
      @_roll = roll
      @_update-transform!

  move-rel: (vec) !->
    mat = mat4.clone @transform
    mat[12] = mat[13] = mat[14] = 0
    vec3.transform-mat4 vec, vec, mat
    vec3.add @pos, @pos, vec
    @_update-transform!

  init-matrices: (gl, matrices) !->
    matrices.set-mode GLMatrices.modes.PROJECTION
    matrices.perspective @fov, gl.viewport-width / gl.viewport-height, @near, @far

  update-matrices: do ->
    inv = mat4.create!
    (gl, matrices) !->
      matrices.set-mode GLMatrices.modes.VIEW
      mat4.invert inv, @transform
      matrices.set-matrix inv
      #matrices.look-at @eye, @center, @up
