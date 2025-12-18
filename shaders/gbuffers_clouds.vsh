#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

varying vec2 texcoord;
varying vec4 color;

void main(void)
{
    gl_Position = ftransform();
    texcoord = gl_MultiTexCoord0.xy;
    color = gl_Color;
}
