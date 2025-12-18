#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

void main(void)
{
    gl_Position = ftransform();
}
