require! {
  './style/clear.styl'
  './style/standard.styl'
}

require! three

export class Renderer
  (config = {}) ->

    @three-renderer = new three.WebGLRenderer antialias: true
      ..set-size window.inner-width, window.inner-height
      ..shadow-map-enabled = true
      ..shadow-map-soft    = true
      ..sort-objects       = false

    self = @

    window.add-event-listener \resize !->
      if self.camera
        self.camera.aspect = window.inner-width / window.inner-height
        self.camera.update-projection-matrix!
      self.three-renderer.set-size window.inner-width, window.inner-height


    @scene = new three.Scene!

    @camera = new three.PerspectiveCamera 75, window.inner-width / window.inner-height, 1, 10000
    @camera.position.z = 1000

    @geometry = new three.BoxGeometry 200, 200, 200
    @material = new three.MeshBasicMaterial color: 0xff0000 wireframe: true

    @mesh = new three.Mesh @geometry, @material
    @scene.add @mesh

    @three-renderer.domElement
      ..id = \wgl-canvas
      .. |> document.body.append-child

  render: !->
    @mesh.rotation.x += 0.01;
    @mesh.rotation.y += 0.02;

    @three-renderer.render @scene, @camera
