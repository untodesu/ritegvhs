#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

uniform sampler2D colortex0;

in vec2 texcoord;

layout(location = 0) out vec4 color;

void main(void)
{
    // Do sharpening with VHS_SHARPEN
    vec2 texSize = vec2(textureSize(colortex0, 0));
    vec2 invTexSize = vec2(1.0) / texSize;

    vec3 sum = vec3(0.0);
    sum += -1.0 * texture(colortex0, texcoord + vec2(-invTexSize.x, -invTexSize.y)).rgb;
    sum += -1.0 * texture(colortex0, texcoord + vec2(0.0, -invTexSize.y)).rgb;
    sum += 5.0 * texture(colortex0, texcoord + vec2(0.0, 0.0)).rgb;
    sum += -1.0 * texture(colortex0, texcoord + vec2(0.0, -invTexSize.y)).rgb;
    sum += -1.0 * texture(colortex0, texcoord + vec2(invTexSize.x, 0.0)).rgb;

    color = vec4(mix(texture(colortex0, texcoord).rgb, sum, VHS_SHARPEN), 1.0);
}
