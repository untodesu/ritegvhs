#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

varying vec2 texcoord;
varying vec4 color;

void main(void)
{
    color = gl_Color;
    texcoord = gl_MultiTexCoord0.xy;
    gl_Position = ftransform();
}
