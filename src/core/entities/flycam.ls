require! {
  'gl-matrix': { mat4 }

  'core/entity.ls': { Entity, EntityTicker }
  'core/entities/cameras.ls': { PerspectiveCamera }
}

export class FlyCamera extends Entity

  ->
    super!

    speed = 0.01

    self = @

    @ticker =
      init: ->
      tick: (delta) !->
        return unless move-left or move-right or move-forward or move-backward
        [ 0 0 0 ]
          ..[0] -= delta * speed if move-left
          ..[0] += delta * speed if move-right
          ..[2] -= delta * speed if move-forward
          ..[2] += delta * speed if move-backward
          self.camera.move-rel ..

    @camera = new PerspectiveCamera 45, 0.1, 1000000.0

    canvas = document.get-element-by-id \wgl-canvas

    canvas.add-event-listener \mousedown !->
      return if document.pointer-lock-element is canvas
      @request-pointer-lock!

    canvas.add-event-listener \mousemove !->
      return unless document.pointer-lock-element is canvas
      mouse-dx = it.movement-x or it.moz-movement-x or it.webkit-movement-x or 0
      mouse-dy = it.movement-y or it.moz-movement-y or it.webkit-movement-y or 0
      mouse-dx *= 0.001
      mouse-dy *= 0.001
      self.camera
        ..yaw   -= mouse-dx
        ..pitch -= mouse-dy

    move-forward  = false
    move-left     = false
    move-backward = false
    move-right    = false
    space-pressed = false

    canvas.add-event-listener \keydown !->
      return unless document.pointer-lock-element is canvas
      switch it.key-code
      | 38 87 # Up or W
        move-forward := true
      | 37 65 # Left or A
        move-left := true
      | 40 83 # Down or S
        move-backward := true
      | 39 68 # Right or D
        move-right := true
      | 32 # Space
        space-pressed := true

    canvas.add-event-listener \keyup !->
      return unless document.pointer-lock-element is canvas
      switch it.key-code
      | 38 87 # Up or W
        move-forward := false
      | 37 65 # Left or A
        move-left := false
      | 40 83 # Down or S
        move-backward := false
      | 39 68 # Right or D
        move-right := false
      | 32 # Space
        space-pressed := false
