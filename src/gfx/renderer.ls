require! {
  'gfx/style/clear.styl'
  'gfx/style/standard.styl'

  'gfx/gl.ls': { GLMatrices }
}

export class WebGLRenderer
  (@game) ->

    canvas = document.create-element \canvas
      ..id = \wgl-canvas
      ..width = window.inner-width
      ..height = window.inner-height
      ..tab-index = 1
      document.body.append-child ..

    @gl = canvas.get-context \webgl
      ..viewport-width = canvas.width
      ..viewport-height = canvas.height

    self = @
    window.add-event-listener \resize !->
      canvas
        ..width = window.inner-width
        ..height = window.inner-height
      self.gl
        ..viewport-width = canvas.width
        ..viewport-height = canvas.height

    # TODO: Handle no WebGL
    @matrices = new GLMatrices!

    /*

    var mvMatrix = mat4.create();
    var pMatrix = mat4.create();

    function setMatrixUniforms() {
        gl.uniformMatrix4fv(shaderProgram.pMatrixUniform, false, pMatrix);
        gl.uniformMatrix4fv(shaderProgram.mvMatrixUniform, false, mvMatrix);
    }



    var triangleVertexPositionBuffer;
    var squareVertexPositionBuffer;

    function initBuffers() {
        triangleVertexPositionBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexPositionBuffer);
        var vertices = [
             0.0,  1.0,  0.0,
            -1.0, -1.0,  0.0,
             1.0, -1.0,  0.0
        ];
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
        triangleVertexPositionBuffer.itemSize = 3;
        triangleVertexPositionBuffer.numItems = 3;

        squareVertexPositionBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexPositionBuffer);
        vertices = [
             1.0,  1.0,  0.0,
            -1.0,  1.0,  0.0,
             1.0, -1.0,  0.0,
            -1.0, -1.0,  0.0
        ];
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
        squareVertexPositionBuffer.itemSize = 3;
        squareVertexPositionBuffer.numItems = 4;
    }


    function drawScene() {
        gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight);
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

        mat4.perspective(45, gl.viewportWidth / gl.viewportHeight, 0.1, 100.0, pMatrix);

        mat4.identity(mvMatrix);

        mat4.translate(mvMatrix, [-1.5, 0.0, -7.0]);
        gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexPositionBuffer);
        gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, triangleVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);
        setMatrixUniforms();
        gl.drawArrays(gl.TRIANGLES, 0, triangleVertexPositionBuffer.numItems);


        mat4.translate(mvMatrix, [3.0, 0.0, 0.0]);
        gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexPositionBuffer);
        gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, squareVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);
        setMatrixUniforms();
        gl.drawArrays(gl.TRIANGLE_STRIP, 0, squareVertexPositionBuffer.numItems);
    }



    function webGLStart() {
        var canvas = document.getElementById("lesson01-canvas");
        initGL(canvas);
        initShaders();
        initBuffers();


        drawScene();
    }

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
    */

  init: !->
    @camera?.init-matrices @gl, @matrices

  render: !->
    @gl.clear-color 0.0, 0.0, 0.0, 1.0
    @gl.enable @gl.DEPTH_TEST

    @gl.viewport 0, 0, @gl.viewport-width, @gl.viewport-height
    @gl.clear @gl.COLOR_BUFFER_BIT .|. @gl.DEPTH_BUFFER_BIT

    @matrices.set-mode GLMatrices.modes.MODEL
    @matrices.set-identity!

    @camera?.update-matrices @gl, @matrices

    @game.scene.renderer.render @gl, @matrices
