precision mediump float;

varying vec2 vUv;
// varying float vCloseness;
varying vec3 vToMouse;
uniform sampler2D uTexture;
uniform vec3 uVecA;

void main() {
  vec2 newUv = vUv;
  vec3 color = texture2D(uTexture, newUv).rgb;

  // gl_FragColor = vec4(color, 1.0);
  // 色デバッグ
  gl_FragColor = vec4(color.r + vToMouse.x, color.g, color.b, 1.0);
}
