#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

uniform float viewWidth;
uniform float viewHeight;

uniform vec3 fogColor;
uniform vec3 skyColor;

void main(void)
{
    vec4 albedo;

    vec4 world_pos = vec4((gl_FragCoord.xy / vec2(viewWidth, viewHeight)) * 2.0f - 1.0f, gl_FragCoord.z * 2.0f - 1.0f, 1.0f);
    world_pos = gbufferProjectionInverse * world_pos;
    world_pos = gbufferModelViewInverse * world_pos;

    float factor = clamp(8.0 * world_pos.y, 0.0, 1.0);
    albedo.rgb = mix(fogColor, skyColor, factor);
    albedo.a = 1.0;

#ifdef SKY_FOG
//    if(renderStage != MC_RENDER_STAGE_SUNSET) {
//        albedo.rgb = mix(albedo.rgb, gl_Fog.color.rgb, smoothstep(gl_Fog.start, gl_Fog.end, vertexDistance));
//    }
#endif
    
    gl_FragData[0] = albedo;
}
