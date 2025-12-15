#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

uniform sampler2D colortex0;

in vec2 texcoord;

layout(location = 0) out vec4 color;

vec3 rgb_to_yiq01(vec3 rgb)
{
    const mat3 convmat = mat3(0.299, 0.587, 0.114, 0.596, -0.274, -0.322, 0.211, -0.523, 0.312);

    vec3 yiq = convmat * rgb;
    yiq.y = yiq.y * 0.5 + 0.5;
    yiq.z = yiq.z * 0.5 + 0.5;

    return yiq;
}

void main(void)
{
    vec3 rgb = texture(colortex0, texcoord).rgb;
    rgb = rgb * step(VHS_CUTOFF, 1.0 - texcoord.x);

    color.xyz = rgb_to_yiq01(rgb);
    color.w = 1.0;

    color.yz = pow(color.yz, vec2(0.975));
    color.yz = 0.5 + VHS_SATURATION * (color.yz - 0.5);

    color.x = smoothstep(0.0, 1.0, color.x);
    color.y = smoothstep(0.0, 1.0, color.y);
    color.z = smoothstep(0.0, 1.0, color.z);

    color.x = pow(color.x, VHS_GAMMA);
}
