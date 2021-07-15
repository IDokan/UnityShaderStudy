Shader "Custom/MaskMap"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("NormalMap", 2D) = "normal"{}
        _MaskMap("MaskMap", 2D) = "white"{}
        _Cube("CubeMap", Cube) = ""{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert noambient
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _MaskMap;
        samplerCUBE _Cube;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float2 uv_MaskMap;
            float3 worldRefl; INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 reflection = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
            float4 mask = tex2D(_MaskMap, IN.uv_MaskMap);

            o.Albedo = c.rgb * (1 - mask.r);
            o.Emission = reflection.rgb * mask.r;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
