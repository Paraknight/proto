$common.vert

varying vec4 worldCoord;

void main(void) {
	worldCoord = modelMatrix * vec4(vertexPos, 1.0);

	gl_Position = projMatrix * viewMatrix * modelMatrix * vec4(vertexPos, 1.0);
}
