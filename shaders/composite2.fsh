#version 330 compatibility

#include "lib/common.glsl"
#include "lib/options.glsl"

uniform sampler2D colortex0;

in vec2 texcoord;

layout(location = 0) out vec4 color;

vec3 VHS_downsampleVideo(vec2 uv, vec2 pixelSize, ivec2 samples)
{
    vec2 uvStart = uv - pixelSize / 2.0;
    vec2 uvEnd = uv + pixelSize;        
    vec3 result = vec3(0.0, 0.0, 0.0);

    for (int i_u = 0; i_u < samples.x; ++i_u) {
        float u = mix(uvStart.x, uvEnd.x, float(i_u) / float(samples.x));

        for (int i_v = 0; i_v < samples.y; ++i_v) {
            float v = mix(uvStart.y, uvEnd.y, float(i_v) / float(samples.y));

            result += texture(colortex0, vec2(u, v)).rgb;
        }
    }    
    
    return result / float(samples.x * samples.y);
}

vec3 VHS_downsampleVideo(vec2 fragCoord, vec2 downsampledRes)
{
    if (fragCoord.x > downsampledRes.x || fragCoord.y > downsampledRes.y) {
        return vec3(0.0, 0.5, 0.5);
    }
    
    vec2 uv = fragCoord / downsampledRes;
    vec2 pixelSize = 1.0 / downsampledRes;
    ivec2 samples = ivec2(8, 1);
    
    pixelSize *= 1.0 + VHS_BLUR_AMT; // Slight box blur to avoid aliasing
    
    return VHS_downsampleVideo(uv, pixelSize, samples);
}

void main(void)
{
    vec2 framesize = textureSize(colortex0, 0);
    vec2 resLuminance = vec2(framesize.x * VHS_LUMA_XRES, framesize.y * VHS_BOTH_YRES);
    vec2 resChroma = vec2(framesize.x * VHS_CHROMA_XRES, framesize.y * VHS_BOTH_YRES);

    color.x = VHS_downsampleVideo(texcoord * framesize, resLuminance).x;
    color.yz = VHS_downsampleVideo(texcoord * framesize, resChroma).yz;

    uint rngStateLuminance = Common_newRngState(texcoord * framesize);
    uint rngStateChroma = Common_newRngState(texcoord * framesize + 37.0);

    color.x += VHS_LUMA_NOISE * (2.0 * Common_randomFloat(rngStateLuminance) - 1.0);
    color.y += VHS_CHROMA_NOISE * (2.0 * Common_randomFloat(rngStateChroma) - 1.0);
    color.z += VHS_CHROMA_NOISE * (2.0 * Common_randomFloat(rngStateChroma) - 1.0);

    color.w = 1.0;
}
