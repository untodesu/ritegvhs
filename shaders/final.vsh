#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

varying vec2 coord0;
varying vec4 color;

void main()
{
    gl_Position = ftransform();
    coord0 = gl_MultiTexCoord0.xy;
    color = gl_Color;
}
