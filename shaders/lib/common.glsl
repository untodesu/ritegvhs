// https://github.com/untodesu/riteg

// ATTRIBUTION ATTRIBUTION ATTRIBUTION ATTRIBUTION
// ATTRIBUTION ATTRIBUTION ATTRIBUTION ATTRIBUTION
// ATTRIBUTION ATTRIBUTION ATTRIBUTION ATTRIBUTION
// ATTRIBUTION ATTRIBUTION ATTRIBUTION ATTRIBUTION
//  VHS Compression: https://www.shadertoy.com/view/tsfXWj
//  NTSC Filter: https://www.shadertoy.com/view/wlScWG

#ifndef COMMON_GLSL
#define COMMON_GLSL

#define PI 3.14159265359
#define RNG_SEED 1337U

#define VHS_GAMMA 0.960
#define VHS_BLUR_AMT 0.2

uniform int frameCounter;

uint Common_newRngStateEx(vec2 uv, uint entropy)
{
    return uint(uint(uv.x) * 1973U + uint(uv.y) * 9277U + uint(frameCounter) * 26699U + entropy * 34961U + RNG_SEED * 41077U) | 1U;
}

uint Common_newRngState(vec2 uv)
{
    return Common_newRngStateEx(uv, 0U);
}

// https://www.shadertoy.com/view/wtSyWm
uint Common_wangHash(inout uint seed)
{
    seed = uint(seed ^ uint(61)) ^ uint(seed >> uint(16));
    seed *= uint(9);
    seed = seed ^ (seed >> 4);
    seed *= uint(0x27d4eb2d);
    seed = seed ^ (seed >> 15);
    return seed;
}

float Common_randomFloat(inout uint state)
{
    return float(Common_wangHash(state)) / 4294967296.0;
}

#endif // COMMON_GLSL
