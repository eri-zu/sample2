precision mediump float;

uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat4 modelMatrix;

attribute vec3 position; // ローカル座標
attribute vec2 uv;
attribute vec2 normal;

uniform float uTime;
uniform vec2 uResolution;
uniform vec3 uCameraPos; // カメラのワールド座標
uniform vec3 uVecA; // カメラからカーソルに向かって伸びるベクトルを正規化したもの（A）
uniform vec3 uCameraDir; // 視線ベクトル

varying vec2 vUv;
varying vec3 vToMouse;

float power = 20.0;

void main() {

  // ------------------------------------------------------------
  // マウスの方向を知る
  // ------------------------------------------------------------
  vec3 p = position;
  vec3 vecA = uVecA;

  // 頂点のワールド座標
  vec4 modelPosition = modelMatrix * vec4(p, 1.0);

  // 視線ベクトル：カメラから板ポリに向かうベクトル（E）
  vec3 eyeVec = uCameraDir;

  // カメラから頂点に向かって伸びるベクトルを正規化したもの（B）
  vec3 vecB = normalize(modelPosition.xyz - uCameraPos);

  // EとBの内積（x）
  float _dotEB = dot(vecB, eyeVec);

  // EとAの内積（y）
  float _dotEA = dot(vecA, eyeVec);

  // uVecAを、positionと同じz座標上まで伸ばす
  vecA *= (_dotEB / _dotEA);

  // zが揃ったので、頂点とマウスの位置関係を調べる
  // 方向知りたいだけなので正規化
  vec3 toMouse = normalize(vecA - vecB);

  // ------------------------------------------------------------
  // 
  // ------------------------------------------------------------

  // // 内積でマウスと頂点の近接レベルを求める（-1〜1）
  float closeness = dot(uVecA, vecB);
  closeness = smoothstep(0.99, 0.99999, closeness);
  // 近接距離に応じて頂点を動かす
  
  vec2 offset = toMouse.xy * power * (1.0 - closeness);
  modelPosition.xy += offset;


  // ------------------------------------------------------------
  // 
  // ------------------------------------------------------------

  vec4 viewPosition = viewMatrix * modelPosition; // ビュー座標
  vec4 projectPosition = projectionMatrix * viewPosition; // プロジェクション座標
  gl_Position = projectPosition; // クリップ座標

  vUv = uv;
}
