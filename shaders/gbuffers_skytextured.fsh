#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

uniform sampler2D texture;

uniform int isEyeInWater;

varying vec2 texcoord;
varying vec4 color;

void main(void)
{
    if(isEyeInWater != 0) {
        discard;
    }
    
    gl_FragData[0] = texture2D(texture, texcoord) * color;
}
