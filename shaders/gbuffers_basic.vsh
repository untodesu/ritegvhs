#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

varying vec4 color;

void main(void)
{
    color = gl_Color;
    gl_Position = ftransform();
}