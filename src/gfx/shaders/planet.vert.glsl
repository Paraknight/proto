$common.vert

varying vec4 vertexCoord;
varying vec4 worldCoord;

void main(void) {
	vertexCoord = vec4(vertexPos, 1.0);
	worldCoord = modelMatrix * vertexCoord;

	gl_Position = projMatrix * viewMatrix * modelMatrix * vec4(vertexPos, 1.0);
}
