Shader "ShaderStudy/Chapter2/uvShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

        _Scaler("Scaler", Range(0, 4)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard 

        sampler2D _MainTex;
        float _Scaler;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + (_Time.y * _Scaler));

            fixed2 result = IN.uv_MainTex + (_Time.y * _Scaler);
            result = result - int2(result);
            o.Emission = float3(result, 0);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
