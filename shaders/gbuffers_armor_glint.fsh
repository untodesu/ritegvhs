#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

uniform sampler2D texture;

uniform int fogShape;
uniform vec3 fogColor;
uniform vec3 skyColor;

varying vec2 texcoord;
varying vec4 color;

uniform float near;
uniform float far;

#ifdef WORLD_FOG
#include "lib/fog.glsl"
#endif

void main(void)
{
    vec4 albedo = texture2D(texture, texcoord) * color * vec4(GLINT_STRENGTH, GLINT_STRENGTH, GLINT_STRENGTH, 1.0f);
    
#ifdef WORLD_FOG
    vec2 params = getFogParams(fogShape, near, far);
    albedo.rgb = mix(albedo.rgb, mix(fogColor, skyColor, params.y), params.x);
#endif
    
    gl_FragData[0] = albedo;
}
