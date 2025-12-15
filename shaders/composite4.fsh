#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

uniform sampler2D colortex0;
uniform sampler2D noisetex;
uniform float frameTimeCounter;

in vec2 texcoord;

layout(location = 0) out vec4 color;

vec4 VHS_cubic(float v)
{
    vec4 n = vec4(1.0, 2.0, 3.0, 4.0) - v;
    vec4 s = n * n * n;
    float x = s.x;
    float y = s.y - 4.0 * s.x;
    float z = s.z - 4.0 * s.y + 6.0 * s.x;
    float w = 6.0 - x - y - z;
    return vec4(x, y, z, w) * (1.0/6.0);
}

vec4 VHS_textureBicubic(sampler2D sampler, vec2 texCoords)
{
    vec2 texSize = vec2(textureSize(sampler, 0));
    vec2 invTexSize = vec2(1.0) / texSize;

    texCoords = texCoords * texSize - 0.5;

    vec2 fxy = fract(texCoords);
    texCoords -= fxy;

    vec4 xcubic = VHS_cubic(fxy.x);
    vec4 ycubic = VHS_cubic(fxy.y);

    vec4 c = texCoords.xxyy + vec2 (-0.5, +1.5).xyxy;

    vec4 s = vec4(xcubic.xz + xcubic.yw, ycubic.xz + ycubic.yw);
    vec4 offset = c + vec4 (xcubic.yw, ycubic.yw) / s;

    offset *= invTexSize.xxyy;

    vec4 sample0 = texture(sampler, offset.xz);
    vec4 sample1 = texture(sampler, offset.yz);
    vec4 sample2 = texture(sampler, offset.xw);
    vec4 sample3 = texture(sampler, offset.yw);

    float sx = s.x / (s.x + s.y);
    float sy = s.z / (s.z + s.w);

    return mix(mix(sample3, sample2, sx), mix(sample1, sample0, sx), sy);
}

vec3 yiq01_to_rgb(vec3 yiq)
{
    const mat3 convmat = mat3(1.0, 0.956, 0.621, 1.0, -0.272, -0.647, 1.0, -1.106, 1.703);

    vec3 yiqstd = yiq;
    yiqstd.y = 2.0 * yiq.y - 1.0;
    yiqstd.z = 2.0 * yiq.z - 1.0;

    return convmat * yiqstd;
}

void main(void)
{
    vec2 framesize = textureSize(colortex0, 0);
    vec2 resLuminance = vec2(framesize.x * VHS_LUMA_XRES, framesize.y * VHS_BOTH_YRES);
    vec2 resChroma = vec2(framesize.x * VHS_CHROMA_XRES, framesize.y * VHS_BOTH_YRES);

    vec2 uvLuminance = clamp(texcoord * resLuminance / framesize, vec2(0.0), vec2(1.0));
    vec2 uvChroma = clamp(texcoord * resChroma / framesize, vec2(0.0), vec2(1.0));

    vec3 yiq;
    yiq.x = VHS_textureBicubic(colortex0, uvLuminance).x;
    yiq.yz = VHS_textureBicubic(colortex0, uvChroma).yz;

    color.rgb = yiq01_to_rgb(yiq);
    color.a = 1.0;
}
