#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

uniform sampler2D texture;

uniform int fogShape;
uniform vec3 fogColor;
uniform vec3 skyColor;

varying vec2 texcoord;
varying vec4 color;

flat varying int id;

uniform float near;
uniform float far;

#ifdef WORLD_FOG
#include "lib/fog.glsl"
#endif

void main(void)
{
    vec4 albedo;

#if MIPMAP_TYPE == 0
    if(id == 10000) {
        albedo = texture2D(texture, texcoord) * color;
    }
    else {
        albedo = texture2DLod(texture, texcoord, 0.0) * color;
    }
#elif MIPMAP_TYPE == 1
    albedo = texture2D(texture, texcoord) * color;
#elif MIPMAP_TYPE == 2
    albedo = texture2DLod(texture, texcoord, 0.0) * color;
#endif
    
#ifdef WORLD_FOG
    vec2 params = getFogParams(fogShape, near, far);
    albedo.rgb = mix(albedo.rgb, mix(fogColor, skyColor, params.y), params.x);
#endif
    
    gl_FragData[0] = albedo;
}
