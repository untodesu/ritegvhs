#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

out vec2 texcoord;

void main(void)
{
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}

