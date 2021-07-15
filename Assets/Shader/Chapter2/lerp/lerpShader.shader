Shader "ShaderStudy/Chapter2/lerpShader"
{
    Properties
    {
        _FirstTex("Lerp First Texture", 2D) = "white" {}
        _SecondTex("Lerp Second Texture", 2D) = "white" {}

        _Scaler("Lerp Scaler", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard 

        sampler2D _FirstTex;
        sampler2D _SecondTex;
        float _Scaler;

        struct Input
        {
            float2 uv_FirstTex;
            float2 uv_SecondTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c1 = tex2D(_FirstTex, IN.uv_FirstTex);
            fixed4 c2 = tex2D(_SecondTex, IN.uv_SecondTex);
            o.Albedo = lerp(c1.rgb, c2.rgb, 1 - c1.a);
            o.Alpha = c1.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
