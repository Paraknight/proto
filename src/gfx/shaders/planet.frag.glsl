$common.frag
$noise4D

uniform float time;

varying vec4 vertexCoord;
varying vec4 worldCoord;

void main(void) {
	//float theta = 0.5 * (1.0 + atan(vertexCoord.y, vertexCoord.x));
	//float phi = 0.5 * (1.0 + atan(length(vertexCoord.xy) / vertexCoord.z));
	//vec4 _vertexCoord = vec4(theta, phi, 1.0, 1.0);
	vec4 _vertexCoord = normalize(vec4(vertexCoord.xyz, 1.0));
	// Six components of noise in a fractal sum
	float n = snoise(_vertexCoord - vec4(0.0, 0.0, 0.0, time));
	n += 0.5 * snoise(_vertexCoord * 2.0 - vec4(0.0, 0.0, 0.0, time*1.4));
	n += 0.25 * snoise(_vertexCoord * 4.0 - vec4(0.0, 0.0, 0.0, time*2.0));
	n += 0.125 * snoise(_vertexCoord * 8.0 - vec4(0.0, 0.0, 0.0, time*2.8));
	n += 0.0625 * snoise(_vertexCoord * 16.0 - vec4(0.0, 0.0, 0.0, time*4.0));
	n += 0.03125 * snoise(_vertexCoord * 32.0 - vec4(0.0, 0.0, 0.0, time*5.6));
	n = n * 0.7;
	// A "hot" colormap - cheesy but effective
	gl_FragColor = vec4(vec3(1.0, 0.5, 0.0) + vec3(n, n, n), 1.0);
	//gl_FragColor = vec4(vec3(noise), 1.0);
}
