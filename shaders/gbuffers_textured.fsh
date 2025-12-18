#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

uniform sampler2D texture;

varying vec2 texcoord;
varying vec4 color;

void main(void)
{
    gl_FragData[0] = texture2D(texture, texcoord) * color;
}