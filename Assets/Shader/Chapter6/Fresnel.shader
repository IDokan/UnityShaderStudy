Shader "ShaderStudy/Chapter6/Fresnel"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpTex("Normal Map", 2D) = "bump" {}
        _RimColor("Rim Color", Color) = (1, 1, 1, 1)
        _RimPower("Rim Power", Range(1, 10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _BumpTex;
        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpTex;
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex));
            o.Albedo = c.rgb;
            o.Alpha = c.a;

            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, _RimPower);
            o.Emission = rim * _RimColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

// How does emission work?
// @: https://forum.unity.com/threads/surface-shader-emission.247564/