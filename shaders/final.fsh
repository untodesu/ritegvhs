#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

uniform sampler2D texture;

varying vec2 coord0;
varying vec4 color;

void main()
{
    gl_FragData[0] = color * texture2D(texture, coord0);
}
