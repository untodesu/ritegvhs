#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

uniform sampler2D texture;

varying vec2 texcoord;
varying vec4 color;

#ifdef CLOUD_FOG
#include "lib/fog.glsl"
#endif

void main(void)
{
    vec4 albedo = color;
    
#ifdef CLOUD_FOG
    float width = gl_Fog.end - gl_Fog.start;
    float newWidth = width * 4.0f;
    
    albedo.a *= 1.0f - getFogParams(0, gl_Fog.start, gl_Fog.start + newWidth).x;
    albedo.rgb = mix(albedo.rgb, gl_Fog.color.rgb, 0.3f);
#endif
    
    gl_FragData[0] = texture2D(texture, texcoord) * albedo;
}
