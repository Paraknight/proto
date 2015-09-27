attribute vec3 vertexPos;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projMatrix;

void main(void) {
	gl_Position = projMatrix * viewMatrix * modelMatrix * vec4(vertexPos, 1.0);
}
