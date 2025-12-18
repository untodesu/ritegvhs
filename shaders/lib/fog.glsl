#ifndef LIB_FOG_GLSL
#define LIB_FOG_GLSL

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

uniform float viewWidth;
uniform float viewHeight;

vec2 getFogParams(int shape, float fogStart, float fogEnd)
{
    vec4 frag_pos = vec4((gl_FragCoord.xy / vec2(viewWidth, viewHeight)) * 2.0f - 1.0f, gl_FragCoord.z * 2.0f - 1.0f, 1.0f);
    vec4 frag_pos_over_w;
    vec4 world_pos;
    vec4 world_pos_over_w;

    frag_pos = gbufferProjectionInverse * frag_pos;
    frag_pos_over_w = frag_pos / frag_pos.w;

    world_pos = gbufferModelViewInverse * frag_pos;
    world_pos_over_w = gbufferModelViewInverse * frag_pos_over_w;
    
    float max_dist;

    switch(shape) {
        case 1: // cylinder
            max_dist = max(length(world_pos_over_w.xz), abs(world_pos_over_w.y));
            break;
        
        default: // sphere
            max_dist = length(frag_pos_over_w.xyz);
            break;
    }

    vec2 result;
    result.x = smoothstep(fogStart, fogEnd, max_dist);
    result.y = clamp(8.0 * world_pos.y, 0.0, 1.0);
    return result;
}

#endif
