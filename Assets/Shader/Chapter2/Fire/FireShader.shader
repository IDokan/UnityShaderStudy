/*
What do we consider to make fire

1. It does not affected by light sources.
2. It moves.
3. It is transparent.
*/

Shader "ShaderStudy/Chapter2/FireShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SecondaryTex("Secondary Texture", 2D) = "white"{}

        _Scaler("Scaler", Range(0, 5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}

        CGPROGRAM
        #pragma surface surf Standard alpha:fade

        sampler2D _MainTex;
        sampler2D _SecondaryTex;
        float _Scaler;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SecondaryTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            /*
            Fire would not be affected by fire because source of light on fire is fire itself.
            How do we do?

            o.Albedo & o.Emission

            o.Emission does not affected by light, o.Albedo does though
            */

            fixed4 d = tex2D(_SecondaryTex, fixed2(IN.uv_SecondaryTex.x, IN.uv_SecondaryTex.y - (_Time.y * _Scaler)));

            o.Emission = c.rgb * d.rgb;
            o.Alpha = c.a * d.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

/*
WARNING!

This is incomplete effect because there are two major reasons.
1. It does not become brighter even though there is something behind of it.
2. This is heavy (not well optimized) effect because "Srandard lighting" is working befind of the scene.
*/
