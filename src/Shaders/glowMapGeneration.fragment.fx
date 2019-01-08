﻿#ifdef DIFFUSE
varying vec2 vUVDiffuse;
uniform sampler2D diffuseSampler;
#endif

#ifdef OPACITY
varying vec2 vUVOpacity;
uniform sampler2D opacitySampler;
uniform float opacityIntensity;
#endif

#ifdef EMISSIVE
varying vec2 vUVEmissive;
uniform sampler2D emissiveSampler;
#endif

uniform vec4 color;

void main(void)
{

vec4 finalColor = color;

// _____________________________ Alpha Information _______________________________
#ifdef DIFFUSE
    vec4 albedoTexture = texture2D(diffuseSampler, vUVDiffuse);
    finalColor.a *= albedoTexture.a;
#endif

#ifdef OPACITY
    vec4 opacityMap = texture2D(opacitySampler, vUVOpacity);

    #ifdef OPACITYRGB
        finalColor.a *= getLuminance(opacityMap.rgb);
    #else
        finalColor.a *= opacityMap.a;
    #endif

    finalColor.a *= opacityIntensity;
#endif

#ifdef VERTEXALPHA
    finalColor.a *= vColor.a;
#endif

#ifdef ALPHATEST
    if (finalColor.a < ALPHATESTVALUE)
        discard;
#endif

#ifdef EMISSIVE
    gl_FragColor = texture2D(emissiveSampler, vUVEmissive) * finalColor;
#else
    gl_FragColor = finalColor;
#endif

    gl_FragColor.rgb *= gl_FragColor.a;
    gl_FragColor.a = 1.0;
}