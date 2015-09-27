$common.frag

void main() {
	//TODO: Add ambient lighting support.
	gl_FragColor = getTexture() * gl_Color * getDiffuse();// * getShadow();
}
