$common.vert

void main() {
	updateTexCoords();
	updateLighting();
	//updateShadow();

	gl_FrontColor = gl_Color;
	gl_Position = getModelViewProjectionMatrix() * gl_Vertex;
}
