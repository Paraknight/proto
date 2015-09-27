require! { 'gl-matrix': { mat4 } }

export class GLMatrices
  @modes =
    MODEL:      0
    VIEW:       1
    PROJECTION: 2

  ->
    @stacks =
      [ mat4.create! ]
      [ mat4.create! ]
      [ mat4.create! ]
    @mode = @@modes.MODEL
    @current-matrix = @stacks[0][0]

  set-mode: !->
    @mode = it
    current-stack = @stacks[it]
    @current-matrix = current-stack[current-stack.length - 1]

  push: !->
    @stacks[@mode].push (@current-matrix .= clone!)

  pop: !->
    @stacks[@mode]
      ..pop!
      @current-matrix = ..[.. .length - 1]

  set-identity: !-> mat4.identity @current-matrix

  set-matrix: !-> mat4.copy @current-matrix, it

  mult-matrix: !-> mat4.multiply @current-matrix, @current-matrix, it

  get-matrix: (mode) ->
    stack = @stacks[mode]
    mat4.clone stack[stack.length - 1]

  translate: (vec) !-> mat4.translate @current-matrix, @current-matrix, vec

  scale: (vec) !-> mat4.scale @current-matrix, @current-matrix, vec

  rotate: (rad, axis) !-> mat4.rotate @current-matrix, @current-matrix, rad, axis

  rotate-x: (rad) !-> mat4.rotate-x @current-matrix, @current-matrix, rad

  rotate-y: (rad) !-> mat4.rotate-y @current-matrix, @current-matrix, rad

  rotate-z: (rad) !-> mat4.rotate-z @current-matrix, @current-matrix, rad

  frustum: (left, right, bottom, top, near, far) !-> mat4.frustum @current-matrix, left, right, bottom, top, near, far

  ortho: (left, right, bottom, top, near, far) !-> mat4.ortho @current-matrix, left, right, bottom, top, near, far

  perspective: (fov, aspect, near, far) !-> mat4.perspective @current-matrix, fov, aspect, near, far

  look-at: (eye, center, up) !-> mat4.look-at @current-matrix, eye, center, up
